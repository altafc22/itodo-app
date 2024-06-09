import 'package:flutter/material.dart';

import 'board_item.dart';
import 'board_view.dart';

typedef OnDropList = void Function(int? listIndex, int? oldListIndex);
typedef OnTapList = void Function(int? listIndex);
typedef OnStartDragList = void Function(int? listIndex);

class BoardList extends StatefulWidget {
  const BoardList(
      {super.key,
      required this.items,
      this.boardViewState,
      this.header,
      this.footer,
      this.listDecoration = const BoxDecoration(
        color: Colors.black12,
        borderRadius: BorderRadius.all(
          Radius.circular(0),
        ),
      ),
      this.headerDecoration,
      this.draggable = true,
      this.index = -1,
      this.onDropList,
      this.onTapList,
      this.onStartDragList,
      this.fullHeight = true});

  final List<Widget>? header;
  final Widget? footer;
  final List<BoardItem> items;
  final BoxDecoration listDecoration;
  final BoxDecoration? headerDecoration;
  final BoardViewState? boardViewState;
  final OnDropList? onDropList;
  final OnTapList? onTapList;
  final OnStartDragList? onStartDragList;
  final bool draggable;
  final int index;
  final bool fullHeight;

  @override
  State<StatefulWidget> createState() {
    return BoardListState();
  }
}

class BoardListState extends State<BoardList>
    with AutomaticKeepAliveClientMixin {
  List<BoardItemState> itemStates = [];
  ScrollController boardListController = ScrollController();

  void onDropList(int? listIndex) {
    if (widget.onDropList != null) {
      widget.onDropList!(listIndex, widget.boardViewState?.startListIndex);
    }
    widget.boardViewState?.draggedListIndex = -1;
    if (widget.boardViewState?.mounted == true) {
      widget.boardViewState?.setState(() {});
    }
  }

  void _startDrag(Widget item, BuildContext context) {
    if (widget.draggable) {
      if (widget.onStartDragList != null) {
        widget.onStartDragList!(widget.index);
      }
      widget.boardViewState?.startListIndex = widget.index;
      widget.boardViewState?.height = context.size!.height;
      widget.boardViewState?.draggedListIndex = widget.index;
      widget.boardViewState?.draggedItemIndex = null;
      widget.boardViewState?.draggedItem = item;
      widget.boardViewState?.onDropList = onDropList;
      widget.boardViewState?.run();
      if (widget.boardViewState?.mounted == true) {
        widget.boardViewState?.setState(() {});
      }
    }
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    List<Widget> listWidgets = [];
    if (widget.header != null) {
      listWidgets.add(GestureDetector(
          onTap: () {
            if (widget.onTapList != null) {
              widget.onTapList!(widget.index);
            }
          },
          onTapDown: (otd) {
            if (widget.draggable) {
              RenderBox object = context.findRenderObject() as RenderBox;
              Offset pos = object.localToGlobal(Offset.zero);
              widget.boardViewState?.initialX = pos.dx;
              widget.boardViewState?.initialY = pos.dy;

              widget.boardViewState?.rightListX = pos.dx + object.size.width;
              widget.boardViewState?.leftListX = pos.dx;
            }
          },
          onTapCancel: () {},
          onLongPress: () {
            if (widget.boardViewState?.widget.isSelecting != true &&
                widget.draggable) {
              _startDrag(widget, context);
            }
          },
          child: Container(
            decoration: widget.headerDecoration,
            child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: widget.header!),
          )));
    }
    listWidgets.add(
      Flexible(
          fit: widget.fullHeight ? FlexFit.tight : FlexFit.loose,
          child: ListView.builder(
            shrinkWrap: true,
            physics: const ClampingScrollPhysics(),
            controller: boardListController,
            itemCount: widget.items.length,
            itemBuilder: (ctx, index) {
              if (widget.items.isNotEmpty) {
                if (widget.items[index].boardList == null ||
                    widget.items[index].index != index ||
                    widget.items[index].boardList!.widget.index !=
                        widget.index ||
                    widget.items[index].boardList != this) {
                  widget.items[index] = BoardItem(
                    boardList: this,
                    item: widget.items[index].item,
                    draggable: widget.items[index].draggable,
                    index: index,
                    onDropItem: widget.items[index].onDropItem,
                    onTapItem: widget.items[index].onTapItem,
                    onDragItem: widget.items[index].onDragItem,
                    onStartDragItem: widget.items[index].onStartDragItem,
                  );
                }
              }
              if (widget.boardViewState?.draggedItemIndex == index &&
                  widget.boardViewState?.draggedListIndex == widget.index) {
                return Opacity(
                  opacity: 0.0,
                  child: widget.items[index],
                );
              } else {
                return widget.items[index];
              }
            },
          )),
    );

    if (widget.footer != null) {
      listWidgets.add(widget.footer!);
    }

    if (widget.boardViewState != null &&
        widget.boardViewState!.listStates.length > widget.index) {
      widget.boardViewState?.listStates.removeAt(widget.index);
    }
    widget.boardViewState?.listStates.insert(widget.index, this);

    return Container(
        margin: const EdgeInsets.all(8),
        decoration: widget.listDecoration,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          children: listWidgets,
        ));
  }
}
