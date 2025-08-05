import 'package:flutter/material.dart';

class CustomSearchableDropDown<T> extends StatefulWidget {
  final List<T> items;
  final ValueChanged<T?> onChanged;
  final String labelText;
  final String hintText;
  final String Function(T) displayValue;
  final FocusNode? focusNode;
  final ValueChanged<String>? onFieldSubmited;
  final bool? autofocus;
  final T? initialSelectedItem;

  const CustomSearchableDropDown({super.key, required this.items, required this.onChanged, required this.labelText, required this.hintText, required this.displayValue, this.focusNode, this.onFieldSubmited, this.autofocus, this.initialSelectedItem});

  @override
  CustomSearchableDropDownState<T> createState() => CustomSearchableDropDownState<T>();
}

class CustomSearchableDropDownState<T> extends State<CustomSearchableDropDown<T>> with SingleTickerProviderStateMixin, WidgetsBindingObserver {
  T? _selectedItem;
  late AnimationController _controller;
  late Animation<double> _heightFactor;
  late TextEditingController _textController;
  late TextEditingController _searchController;
  OverlayEntry? _overlayEntry;
  bool _isHovering = false;
  final LayerLink _layerLink = LayerLink();
  List<T> _filteredItems = [];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 300));
    _heightFactor = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);

    setState(() {
      _textController = TextEditingController();
    });
    _searchController = TextEditingController();

    if (widget.initialSelectedItem != null) {
      _selectedItem = widget.initialSelectedItem;
      _textController.text = widget.displayValue(_selectedItem as T);
    }

    _filteredItems = widget.items;

    _searchController.addListener(() {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _filterItems();
      });
    });

    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    _controller.dispose();
    _textController.dispose();
    _searchController.dispose();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  void _filterItems() {
    setState(() {
      final searchText = _searchController.text.toLowerCase();
      _filteredItems = widget.items.where((item) {
        final displayText = widget.displayValue(item).toLowerCase();
        return displayText.contains(searchText);
      }).toList();
    });
  }

  void _toggleDropdown() {
    if (_overlayEntry == null) {
      _overlayEntry = _createOverlayEntry();
      Overlay.of(context).insert(_overlayEntry!);
      _controller.forward();
    } else {
      _overlayEntry?.remove();
      _overlayEntry = null;
      _controller.reverse();
    }
  }

  void setSelectedItem(T item) {
    setState(() {
      _selectedItem = item;
      _textController.text = widget.displayValue(item);
      widget.onChanged(item);
    });
    _toggleDropdown();
  }

  @override
  void didChangeMetrics() {
    super.didChangeMetrics();
    if (_overlayEntry != null) {
      _toggleDropdown();
    }
  }

  OverlayEntry _createOverlayEntry() {
    final RenderBox renderBox = context.findRenderObject() as RenderBox;
    final offset = renderBox.localToGlobal(Offset.zero);
    final size = renderBox.size;

    return OverlayEntry(
      builder: (context) {
        return GestureDetector(
          behavior: HitTestBehavior.translucent,
          // onTap: _toggleDropdown, // Esto cierra el overlay al hacer clic fuera de él
          child: Stack(
            children: [
              Positioned(
                left: offset.dx,
                top: offset.dy + size.height,
                width: size.width,
                child: CompositedTransformFollower(
                  link: this._layerLink,
                  child: Material(
                    color: Colors.transparent,
                    child: SizeTransition(
                      sizeFactor: _heightFactor,
                      axisAlignment: -1.0,
                      child: GestureDetector(
                        onTap: () => _toggleDropdown(),
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.black87),
                            borderRadius: BorderRadius.circular(size.width * 0.03),
                            color: Colors.black54,
                          ),
                          constraints: BoxConstraints(maxHeight: size.height * 5),
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                                child: TextField(
                                  controller: _searchController, // Se asegura que el controller correcto se está usando
                                  autofocus: true, // Asegura que el campo de búsqueda tenga enfoque
                                  decoration: const InputDecoration(
                                    hintText: 'Buscar...',
                                    hintStyle: TextStyle(color: Color.fromRGBO(129, 204, 45, 1), fontFamily: 'Poppins', fontStyle: FontStyle.italic),
                                  ),
                                  style: const TextStyle(color: Color.fromRGBO(129, 204, 45, 1), fontFamily: 'Poppins'),
                                ),
                              ),
                              Expanded(
                                child: SingleChildScrollView(
                                  child: Column(
                                    children: _filteredItems.map((T value) {
                                      bool isSelected = _selectedItem == value;
                                      bool isHovered = false;
                                      return StatefulBuilder(
                                        builder: (BuildContext context, StateSetter setState) {
                                          return MouseRegion(
                                            onEnter: (_) {
                                              setState(() {
                                                isHovered = true;
                                              });
                                            },
                                            onExit: (_) {
                                              setState(() {
                                                isHovered = false;
                                              });
                                            },
                                            child: InkWell(
                                              onTap: () {
                                                setSelectedItem(value);
                                              },
                                              child: Container(
                                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
                                                decoration: BoxDecoration(
                                                  color: isSelected
                                                      ? const Color.fromRGBO(128, 32, 179, 0.2)
                                                      : isHovered
                                                      ? const Color.fromRGBO(128, 32, 179, 0.2)
                                                      : Colors.transparent,
                                                  borderRadius: BorderRadius.circular(size.width * 0.025),
                                                ),
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: <Widget>[
                                                    Text(
                                                      widget.displayValue(value),
                                                      style: const TextStyle(color: Color.fromRGBO(129, 204, 45, 1), fontFamily: 'Poppins'),
                                                    ),
                                                    if (isSelected) const Icon(Icons.check, color: Color.fromRGBO(129, 204, 45, 1)),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          );
                                        },
                                      );
                                    }).toList(),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    const hoverColor = Color.fromRGBO(128, 32, 179, 0.2);

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) {
        setState(() {
          _isHovering = true;
        });
      },
      onExit: (_) {
        setState(() {
          _isHovering = false;
        });
      },
      child: CompositedTransformFollower(
        link: this._layerLink,
        child: GestureDetector(
          onTap: _toggleDropdown,
          child: AbsorbPointer(
            child: TextField(
              controller: _textController,
              readOnly: true,
              focusNode: widget.focusNode,
              onSubmitted: widget.onFieldSubmited,
              onTap: _toggleDropdown,
              style: const TextStyle(fontFamily: 'Poppins'),
              decoration: InputDecoration(
                labelText: widget.labelText,
                labelStyle: const TextStyle(color: Colors.black87, fontFamily: 'Poppins', fontWeight: FontWeight.w500),
                hintText: widget.hintText,
                hintStyle: const TextStyle(color: Colors.black87, fontFamily: 'Poppins', fontStyle: FontStyle.italic),
                filled: true,
                fillColor: _isHovering ? hoverColor : Colors.transparent,
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(size.width * 0.008),
                  borderSide: BorderSide(color: Colors.black87, width: size.width * 0.0007),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(size.width * 0.008),
                  borderSide: BorderSide(color: Colors.black87, width: size.width * 0.0007 * 3),
                ),
                contentPadding: EdgeInsets.symmetric(vertical: size.height * 0.02, horizontal: size.width * 0.0125),
                suffixIcon: const Icon(Icons.arrow_drop_down, color: Colors.black87),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
