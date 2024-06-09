import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:itodo/common/utils/log_utils.dart';

import 'board_list.dart';

typedef OnDropItem = void Function(int? listIndex, int? itemIndex,
    int? oldListIndex, int? oldItemIndex, BoardItemState state);
typedef OnTapItem = void Function(
    int? listIndex, int? itemIndex, BoardItemState state);
typedef OnStartDragItem = void Function(
    int? listIndex, int? itemIndex, BoardItemState state);
typedef OnDragItem = void Function(int oldListIndex, int oldItemIndex,
    int newListIndex, int newItemIndex, BoardItemState state);

class BoardItem extends StatefulWidget {
  final BoardListState? boardList;
  final Widget? item;
  final int? index;
  final OnDropItem? onDropItem;
  final OnTapItem? onTapItem;
  final OnStartDragItem? onStartDragItem;
  final OnDragItem? onDragItem;
  final bool draggable;

  const BoardItem(
      {Key? key,
      this.boardList,
      this.item,
      this.index,
      this.onDropItem,
      this.onTapItem,
      this.onStartDragItem,
      this.draggable = true,
      this.onDragItem})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return BoardItemState();
  }
}

class BoardItemState extends State<BoardItem>
    with AutomaticKeepAliveClientMixin {
  late double height;
  double? width;

  @override
  bool get wantKeepAlive => true;

  void onDropItem(int? listIndex, int? itemIndex) {
    if (widget.onDropItem != null) {
      widget.onDropItem!(
          listIndex,
          itemIndex,
          widget.boardList!.widget.boardViewState!.startListIndex,
          widget.boardList!.widget.boardViewState!.startItemIndex,
          this);
    }
    widget.boardList!.widget.boardViewState?.draggedItemIndex = null;
    widget.boardList!.widget.boardViewState?.draggedListIndex = null;
    if (widget
        .boardList!.widget.boardViewState!.listStates[listIndex!].mounted) {
      widget.boardList!.widget.boardViewState!.listStates[listIndex]
          .setState(() {});
    }
  }

  void _startDrag(Widget item, BuildContext context) {
    if (widget.boardList!.widget.boardViewState != null) {
      widget.boardList!.widget.boardViewState!.onDropItem = onDropItem;
      if (widget.boardList!.mounted) {
        widget.boardList!.setState(() {});
      }
      widget.boardList!.widget.boardViewState!.draggedItemIndex = widget.index;
      widget.boardList!.widget.boardViewState!.height = context.size!.height;
      widget.boardList!.widget.boardViewState!.draggedListIndex =
          widget.boardList!.widget.index;
      widget.boardList!.widget.boardViewState!.startListIndex =
          widget.boardList!.widget.index;
      widget.boardList!.widget.boardViewState!.startItemIndex = widget.index;
      widget.boardList!.widget.boardViewState!.draggedItem = item;
      if (widget.onStartDragItem != null) {
        widget.onStartDragItem!(
            widget.boardList!.widget.index, widget.index, this);
      }
      widget.boardList!.widget.boardViewState!.run();
      if (widget.boardList!.widget.boardViewState!.mounted) {
        widget.boardList!.widget.boardViewState!.setState(() {});
      }
    }
  }

  void afterFirstLayout(BuildContext context) {
    try {
      height = context.size!.height;
      width = context.size!.width;
    } catch (e) {
      printInfo(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    WidgetsBinding.instance
        .addPostFrameCallback((_) => afterFirstLayout(context));
    if (widget.boardList!.itemStates.length > widget.index!) {
      widget.boardList!.itemStates.removeAt(widget.index!);
    }
    widget.boardList!.itemStates.insert(widget.index!, this);
    return GestureDetector(
      onTapDown: (otd) {
        if (widget.draggable) {
          RenderBox object = context.findRenderObject() as RenderBox;
          Offset pos = object.localToGlobal(Offset.zero);
          RenderBox box =
              widget.boardList!.context.findRenderObject() as RenderBox;
          Offset listPos = box.localToGlobal(Offset.zero);
          widget.boardList!.widget.boardViewState!.leftListX = listPos.dx;
          widget.boardList!.widget.boardViewState!.topListY = listPos.dy;
          widget.boardList!.widget.boardViewState!.topItemY = pos.dy;
          widget.boardList!.widget.boardViewState!.bottomItemY =
              pos.dy + object.size.height;
          widget.boardList!.widget.boardViewState!.bottomListY =
              listPos.dy + box.size.height;
          widget.boardList!.widget.boardViewState!.rightListX =
              listPos.dx + box.size.width;

          widget.boardList!.widget.boardViewState!.initialX = pos.dx;
          widget.boardList!.widget.boardViewState!.initialY = pos.dy;
        }
      },
      onTapCancel: () {},
      onTap: () {
        if (widget.onTapItem != null) {
          widget.onTapItem!(widget.boardList!.widget.index, widget.index, this);
        }
      },
      onLongPress: () {
        if (!widget.boardList!.widget.boardViewState!.widget.isSelecting &&
            widget.draggable) {
          _startDrag(widget, context);
        }
      },
      child: widget.item,
    );
  }
}
