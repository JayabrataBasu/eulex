import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'matrix_state.dart';

class MatrixScreen extends StatelessWidget {
  const MatrixScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<MatrixState>();
    return Scaffold(
      appBar: AppBar(title: const Text('Matrix Calculator')),
      body: Column(
        children: [
          _OperationBar(state: state),
          _TabSwitcher(state: state),
          Expanded(child: _MatrixView(state: state)),
          if (state.error != null)
            Container(
              width: double.infinity,
              color: Colors.red.shade100,
              padding: const EdgeInsets.all(8),
              child: Text(
                state.error!,
                style: const TextStyle(color: Colors.red),
              ),
            ),
        ],
      ),
    );
  }
}

class _OperationBar extends StatelessWidget {
  const _OperationBar({required this.state});
  final MatrixState state;
  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 4,
      children: [
        _opBtn(context, '+', MatrixOperation.add),
        _opBtn(context, '-', MatrixOperation.subtract),
        _opBtn(context, '×', MatrixOperation.multiply),
        _opBtn(context, 'det', MatrixOperation.det),
        _opBtn(context, 'T', MatrixOperation.transpose),
        _opBtn(context, '⁻¹', MatrixOperation.inverse),
      ],
    );
  }

  Widget _opBtn(BuildContext ctx, String label, MatrixOperation op) =>
      ElevatedButton(onPressed: () => state.perform(op), child: Text(label));
}

class _TabSwitcher extends StatelessWidget {
  const _TabSwitcher({required this.state});
  final MatrixState state;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        for (final tab in MatrixTab.values)
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: ChoiceChip(
              label: Text(switch (tab) {
                MatrixTab.a => 'Matrix A',
                MatrixTab.b => 'Matrix B',
                MatrixTab.result => 'Result',
              }),
              selected: state.currentTab == tab,
              onSelected: (_) => state.setTab(tab),
            ),
          ),
      ],
    );
  }
}

class _MatrixView extends StatelessWidget {
  const _MatrixView({required this.state});
  final MatrixState state;

  @override
  Widget build(BuildContext context) {
    switch (state.currentTab) {
      case MatrixTab.a:
        return _EditableMatrix(
          rows: state.rowsA,
          cols: state.colsA,
          onDimChange: (r, c) => state.setDimensionsA(r, c),
          onCellChanged: state.updateCellA,
          data: state.dataA,
          label: 'A',
        );
      case MatrixTab.b:
        return _EditableMatrix(
          rows: state.rowsB,
          cols: state.colsB,
          onDimChange: (r, c) => state.setDimensionsB(r, c),
          onCellChanged: state.updateCellB,
          data: state.dataB,
          label: 'B',
        );
      case MatrixTab.result:
        final r = state.result;
        if (r == null) return const Center(child: Text('No result yet'));
        final list = r.toList().map((row) => row.toList()).toList();
        return _ReadOnlyMatrix(data: list, label: 'Result');
    }
  }
}

class _EditableMatrix extends StatelessWidget {
  const _EditableMatrix({
    required this.rows,
    required this.cols,
    required this.onDimChange,
    required this.onCellChanged,
    required this.data,
    required this.label,
  });
  final int rows;
  final int cols;
  final void Function(int r, int c) onDimChange;
  final void Function(int r, int c, String v) onCellChanged;
  final List<List<double>> data;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _numberDropdown('Rows', rows, (v) => onDimChange(v, cols)),
            const SizedBox(width: 16),
            _numberDropdown('Cols', cols, (v) => onDimChange(rows, v)),
          ],
        ),
        const SizedBox(height: 12),
        Expanded(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Column(
              children: [
                for (int r = 0; r < rows; r++)
                  Row(
                    children: [
                      for (int c = 0; c < cols; c++)
                        SizedBox(
                          width: 60,
                          child: Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: TextField(
                              keyboardType:
                                  const TextInputType.numberWithOptions(
                                    decimal: true,
                                  ),
                              decoration: const InputDecoration(
                                isDense: true,
                                border: OutlineInputBorder(),
                              ),
                              controller:
                                  TextEditingController(
                                      text: data[r][c].toString(),
                                    )
                                    ..selection = TextSelection.fromPosition(
                                      TextPosition(
                                        offset: data[r][c].toString().length,
                                      ),
                                    ),
                              onChanged: (v) => onCellChanged(r, c, v),
                            ),
                          ),
                        ),
                    ],
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _numberDropdown(
    String label,
    int current,
    ValueChanged<int> onChanged,
  ) {
    return Row(
      children: [
        Text(label),
        const SizedBox(width: 8),
        DropdownButton<int>(
          value: current,
          items: [
            for (int i = 1; i <= 6; i++)
              DropdownMenuItem(value: i, child: Text('$i')),
          ],
          onChanged: (v) {
            if (v != null) onChanged(v);
          },
        ),
      ],
    );
  }
}

class _ReadOnlyMatrix extends StatelessWidget {
  const _ReadOnlyMatrix({required this.data, required this.label});
  final List<List<double>> data;
  final String label;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            for (int r = 0; r < data.length; r++)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  for (int c = 0; c < data[r].length; c++)
                    Container(
                      width: 60,
                      margin: const EdgeInsets.all(4),
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        data[r][c].toStringAsFixed(3),
                        textAlign: TextAlign.center,
                      ),
                    ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
