import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:medquest/core/typedefs/type_defs.dart';
import 'package:medquest/research/data/service/research_firestore_interface.dart';
import 'package:medquest/research/domain/models/research_entity.dart';
import 'package:medquest/research/domain/models/research_mapper.dart';
import '../../../core/failure/failure.dart';
import '../../../core/patterns/result.dart';
import 'package:excel/excel.dart';
import 'package:file_saver/file_saver.dart';
import 'package:path_provider/path_provider.dart';
import 'package:medquest/research/domain/models/score_chart_data.dart';
import 'dart:io';

final class ResearchFirestoreService implements IResearchFirestore {
  static const String _collection = 'Research';

  final FirebaseFirestore _firestore;

  ResearchFirestoreService({required FirebaseFirestore firestore})
    : _firestore = firestore;

  @override
  Future<ResearchResult> createResearch(Research research) async {
    try {
      final researchToCreate = research.copyWith(date: DateTime.now());
      final snapshot = await _firestore
          .collection(_collection)
          .add(ResearchMapper.toMap(researchToCreate));

      var researchCreated = await getResearch(snapshot.id);

      if (researchCreated is Error) {
        return Error(
          ApiLocalFailure('Firestore - Erro ao obter pesquisa criada'),
        );
      }

      return researchCreated;
    } catch (e) {
      return Error(ApiLocalFailure('Firestore - Erro ao salvar pesquisa: $e'));
    }
  }

  @override
  Future<ResearchResult> getResearch(String researchId) async {
    try {
      final snapshot = await _firestore
          .collection(_collection)
          .doc(researchId)
          .get();

      if (!snapshot.exists || snapshot.data() == null) {
        return Error(EmptyResultFailure());
      }

      final research = ResearchMapper.fromMap(
        snapshot.data()!,
        documentId: snapshot.id,
      );
      return Success(research);
    } catch (e) {
      return Error(ApiLocalFailure('Firestore - Erro ao obter pesquisa: $e'));
    }
  }

  @override
  Future<ResearchesResult> getResearches(List<String> researchIds) async {
    try {
      final collection = _firestore.collection(_collection);
      final snapshot = researchIds.isEmpty
          ? await collection.get()
          : await collection
                .where(FieldPath.documentId, whereIn: researchIds)
                .get();

      final researches = snapshot.docs.map((doc) {
        final data = Map<String, dynamic>.from(doc.data());

        return ResearchMapper.fromMap(data, documentId: doc.id);
      }).toList();

      return Success(researches);
    } catch (e) {
      return Error(ApiLocalFailure('Firestore - Erro ao obter pesquisa: $e'));
    }
  }

  @override
  Future<ResearchResult> updateResearch(Research research) async {
    try {
      await _firestore
          .collection(_collection)
          .doc(research.id)
          .update(ResearchMapper.toMap(research));

      final updatedResearch = await getResearch(research.id);

      return updatedResearch;
    } catch (e) {
      return Error(
        ApiLocalFailure('Firestore - Erro ao atualizar pesquisa: $e'),
      );
    }
  }

  @override
  Future<VoidResult> deleteResearch(String researchId) async {
    try {
      await _firestore.collection(_collection).doc(researchId).delete();

      return Success(null);
    } catch (e) {
      return Error(ApiLocalFailure('Firestore - Erro ao deletar pesquisa: $e'));
    }
  }

  @override
  Future<VoidResult> archiveResearch(String researchId) async {
    try {
      await _firestore.collection(_collection).doc(researchId).update({
        'archived': true,
      });

      return Success(null);
    } catch (e) {
      return Error(
        ApiLocalFailure('Firestore - Erro ao arquivar pesquisa: $e'),
      );
    }
  }

  @override
  Future<VoidResult> unarchiveResearch(String researchId) async {
    try {
      await _firestore.collection(_collection).doc(researchId).update({
        'archived': false,
      });

      return Success(null);
    } catch (e) {
      return Error(
        ApiLocalFailure('Firestore - Erro ao desarquivar pesquisa: $e'),
      );
    }
  }

  @override
  Future<VoidResult> exportResearchToExcel(String researchId) async {
    try {
      final groupsSnapshot = await _firestore
          .collection('Research')
          .doc(researchId)
          .collection('Group')
          .get();

      List<Map<String, dynamic>> processedPatientsData = [];
      Set<String> dynamicQuestionnaireColumns = {};

      for (var groupDoc in groupsSnapshot.docs) {
        final groupName = groupDoc.data()['name'] ?? 'Grupo';
        final patientsSnapshot = await groupDoc.reference
            .collection('Patient')
            .get();

        for (var patientDoc in patientsSnapshot.docs) {
          final patientData = patientDoc.data();

          Map<String, dynamic> rowData = {
            'ID': patientDoc.id,
            'Age': calculateAge(patientData['birthDate']),
            'Sex': patientData['sex'] ?? '',
            'Group': groupName,
            'Birth Placement': patientData['birthPlacement'] ?? '',
            'Comorbidities': patientData['comorbidities'] ?? '',
            'Research Attributes': patientData['researchAttributes'] ?? '',
            'Height': patientData['height'] ?? '',
            'Weight': patientData['weight'] ?? '',
            'Ethnicity': patientData['ethnicity'] ?? '',
            'Smoking': patientData['smokingLevel'] ?? '',
            'Drugs': patientData['drugs'] ?? '',
            'Elitism': patientData['elitism'] ?? '',
            'Income': patientData['income'] ?? '',
            'Education': patientData['educationLevel'] ?? '',
            'Exit Reason': patientData['exitReason'] ?? '',
          };

          final answeredQuestsSnapshot = await patientDoc.reference
              .collection('AnsweredQuest')
              .get();

          for (var questDoc in answeredQuestsSnapshot.docs) {
            final questData = questDoc.data();
            String questColumnName = questData['name'] ?? 'Questionário';

            num totalScore = 0;
            bool hasScore = false;
            final questionsSnapshot = await questDoc.reference
                .collection('Questions')
                .get();

            for (var qDoc in questionsSnapshot.docs) {
              final rawScore = qDoc.data()['score'];
              if (rawScore != null) {
                final parsedScore = rawScore is num
                    ? rawScore
                    : num.tryParse(rawScore.toString());
                if (parsedScore != null) {
                  totalScore += parsedScore;
                  hasScore = true;
                }
              }
            }

            dynamicQuestionnaireColumns.add(questColumnName);
            rowData[questColumnName] = hasScore ? totalScore : '';

            dynamicQuestionnaireColumns.add(questColumnName);
            rowData[questColumnName] = totalScore;
          }

          processedPatientsData.add(rowData);
        }
      }

      final sortedDynamicColumns = dynamicQuestionnaireColumns.toList()
        ..sort((a, b) {
          List<String> partsA = a.split(' ');
          List<String> partsB = b.split(' ');

          if (partsA.length >= 2 && partsB.length >= 2) {
            String timeA = partsA[0];
            String nameA = partsA.sublist(1).join(' ');

            String timeB = partsB[0];
            String nameB = partsB.sublist(1).join(' ');

            int nameComparison = nameA.compareTo(nameB);
            if (nameComparison != 0) {
              return nameComparison;
            }

            return timeA.compareTo(timeB);
          }

          return a.compareTo(b);
        });

      List<String> fixedHeaders = [
        'ID',
        'Age',
        'Sex',
        'Group',
        'Birth Placement',
        'Comorbidities',
        'Research Attributes',
        'Height',
        'Weight',
        'Ethnicity',
        'Smoking',
        'Drugs',
        'Elitism',
        'Income',
        'Education',
        'Exit Reason',
      ];
      List<String> allHeaders = [...fixedHeaders, ...sortedDynamicColumns];

      var excel = Excel.createExcel();
      Sheet sheetObject = excel['Relatório da Pesquisa'];
      excel.setDefaultSheet('Relatório da Pesquisa');
      excel.delete('Sheet1');

      sheetObject.appendRow(allHeaders.map((h) => TextCellValue(h)).toList());

      for (var patientData in processedPatientsData) {
        List<CellValue> rowCells = [];

        for (String header in allHeaders) {
          var value = patientData[header];

          if (value == null) {
            rowCells.add(TextCellValue(''));
          } else if (value is int) {
            rowCells.add(IntCellValue(value));
          } else if (value is double) {
            rowCells.add(DoubleCellValue(value));
          } else {
            rowCells.add(TextCellValue(value.toString()));
          }
        }

        sheetObject.appendRow(rowCells);
      }

      var fileBytes = excel.save();
      if (fileBytes != null) {
        final directory = await getTemporaryDirectory();
        String filePath =
            '${directory.path}/relatorio_pesquisa_$researchId.xlsx';

        final file = File(filePath);
        await file.writeAsBytes(fileBytes);

        return Success(null);
      }

      return Error(
        ApiLocalFailure('Falha ao gerar os bytes do arquivo Excel.'),
      );
    } catch (e) {
      return Error(ApiLocalFailure('Erro ao exportar pesquisa para Excel: $e'));
    }
  }

  int calculateAge(String? birthDateString) {
    if (birthDateString == null || birthDateString.isEmpty) return 0;

    try {
      DateTime birthDate = DateTime.parse(birthDateString);
      DateTime today = DateTime.now();

      int age = today.year - birthDate.year;

      if (today.month < birthDate.month ||
          (today.month == birthDate.month && today.day < birthDate.day)) {
        age--;
      }

      return age;
    } catch (e) {
      return 0;
    }
  }

  @override
  Future<ChartDataResult> getScoreChartData(String researchId) async {
    try {
      Map<String, Map<String, List<num>>> groupTimeScoresMap = {};

      final groupsSnapshot = await _firestore
          .collection('Research')
          .doc(researchId)
          .collection('Group')
          .get();

      for (var groupDoc in groupsSnapshot.docs) {
        final groupName = groupDoc.data()['name'] ?? 'Grupo';

        groupTimeScoresMap.putIfAbsent(groupName, () => {});

        final patientsSnapshot = await groupDoc.reference
            .collection('Patient')
            .get();

        for (var patientDoc in patientsSnapshot.docs) {
          final answeredQuestsSnapshot = await patientDoc.reference
              .collection('AnsweredQuest')
              .get();

          for (var questDoc in answeredQuestsSnapshot.docs) {
            final questData = questDoc.data();
            String questName = questData['name'] ?? '';

            if (questName.isEmpty) continue;

            List<String> parts = questName.split(' ');
            String timeLabel = parts.isNotEmpty ? parts[0] : 'T0';

            num totalScoreForThisQuest = 0;
            final questionsSnapshot = await questDoc.reference
                .collection('Questions')
                .get();

            for (var qDoc in questionsSnapshot.docs) {
              final rawScore = qDoc.data()['score'];
              if (rawScore != null) {
                final parsedScore = rawScore is num
                    ? rawScore
                    : num.tryParse(rawScore.toString());
                if (parsedScore != null) {
                  totalScoreForThisQuest += parsedScore;
                }
              }
            }

            groupTimeScoresMap[groupName]!.putIfAbsent(timeLabel, () => []);
            groupTimeScoresMap[groupName]![timeLabel]!.add(
              totalScoreForThisQuest,
            );
          }
        }
      }

      Map<String, List<ScoreChartData>> finalChartData = {};

      groupTimeScoresMap.forEach((groupName, timeMap) {
        List<ScoreChartData> points = [];

        timeMap.forEach((timeLabel, scoresList) {
          double average = scoresList.isNotEmpty
              ? scoresList.reduce((a, b) => a + b) / scoresList.length
              : 0.0;

          double weekIndex = _parseWeekIndex(timeLabel);

          points.add(
            ScoreChartData(
              weekIndex: weekIndex,
              timeLabel: timeLabel,
              averageScore: average,
            ),
          );
        });

        points.sort((a, b) => a.weekIndex.compareTo(b.weekIndex));
        finalChartData[groupName] = points;
      });

      return Success(finalChartData);
    } catch (e) {
      return Error(ApiLocalFailure('Erro ao gerar dados para o gráfico: $e'));
    }
  }

  double _parseWeekIndex(String timeLabel) {
    String cleanNumber = timeLabel.replaceAll(RegExp(r'[^0-9]'), '');
    return double.tryParse(cleanNumber) ?? 0.0;
  }
}
