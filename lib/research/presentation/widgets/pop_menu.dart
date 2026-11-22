import 'package:material_ui/material_ui.dart';

class PopMenu extends StatefulWidget {
  final List<MenuSection> sections;

  const PopMenu({super.key, required this.sections});

  @override
  State<PopMenu> createState() => _PopMenuState();
}

class _PopMenuState extends State<PopMenu> {
  final LayerLink _layerLink = LayerLink();
  OverlayEntry? _overlayEntry;

  static const Color menuColor = Color(0xFF401B4D);
  static const Color iconColor = Color(0xFF765080);
  static const Color textColor = Color(0xFFF5EDF8);

  void _toggleMenu() {
    if (_overlayEntry != null) {
      _closeMenu();
    } else {
      _showMenu();
    }
  }

  void _showMenu() {
    _overlayEntry = OverlayEntry(
      builder: (context) {
        return Stack(
          children: [
            // Fecha o menu ao clicar fora dele
            Positioned.fill(
              child: GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: _closeMenu,
                child: const SizedBox.expand(),
              ),
            ),

            // Posiciona o menu em relação ao botão
            CompositedTransformFollower(
              link: _layerLink,
              showWhenUnlinked: false,
              targetAnchor: Alignment.bottomRight,
              followerAnchor: Alignment.topRight,
              offset: const Offset(-16, 8),
              child: Material(color: Colors.transparent, child: _buildMenu()),
            ),
          ],
        );
      },
    );

    Overlay.of(context).insert(_overlayEntry!);
  }

  void _closeMenu() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  Widget _buildMenu() {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          width: 180,
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          decoration: BoxDecoration(
            color: menuColor,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (int i = 0; i < widget.sections.length; i++) ...[
                _buildSection(widget.sections[i]),

                if (i < widget.sections.length - 1)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Divider(
                      color: Colors.white.withValues(alpha: 0.55),
                      thickness: 1,
                      height: 1,
                    ),
                  ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSection(MenuSection section) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 5, top: 2),
          child: Text(
            section.title.toUpperCase(),
            style: const TextStyle(
              color: Color(0xFFD3A9E2),
              fontSize: 14,
              letterSpacing: 1,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),

        ...section.items.map(_buildItem),
      ],
    );
  }

  Widget _buildItem(MenuAction item) {
    return InkWell(
      onTap: () {
        _closeMenu();
        item.onTap();
      },
      borderRadius: BorderRadius.circular(6),
      child: SizedBox(
        height: 40,
        child: Row(
          children: [
            Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                color: iconColor,
                borderRadius: BorderRadius.circular(5),
              ),
              child: Icon(item.icon, color: Colors.white, size: 23),
            ),

            const SizedBox(width: 8),

            Expanded(
              child: Text(
                item.label,
                style: TextStyle(
                  color: item.isDestructive ? Colors.redAccent : textColor,
                  fontSize: 15,
                  letterSpacing: 0.5,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _closeMenu();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _layerLink,
      child: IconButton(
        onPressed: _toggleMenu,
        icon: const Icon(Icons.more_vert, color: Colors.white, size: 25),
      ),
    );
  }
}

// Modelo das seções do menu
class MenuSection {
  final String title;
  final List<MenuAction> items;

  const MenuSection({required this.title, required this.items});
}

// Modelo de cada opção
class MenuAction {
  final String label;
  final IconData icon;
  final VoidCallback onTap;
  final bool isDestructive;

  const MenuAction({
    required this.label,
    required this.icon,
    required this.onTap,
    this.isDestructive = false,
  });
}
