import 'package:fanfan/service/entities/transaction/amount_grouped_by_category.dart';
import 'package:fanfan/store/category.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fanfan/service/entities/category.dart' as entities
    show Category;

class CategoryAmountsPie extends StatefulWidget {
  final List<AmountGroupedByCategory> amounts;

  const CategoryAmountsPie({
    super.key,
    required this.amounts,
  });

  @override
  State<CategoryAmountsPie> createState() => _State();
}

class _State extends State<CategoryAmountsPie> {
  List<_Section> get _sections {
    final categories = context.read<Category>().categories;
    return widget.amounts
        .asMap()
        .entries
        .map((e) => _Section(
            color: Colors.primaries.elementAt(e.key).shade500,
            category: categories
                .firstWhere((category) => category.id == e.value.categoryId),
            amount: e.value.amount!))
        .toList();
  }

  double get _totalAmount {
    return widget.amounts
        .fold(0.0, (previousValue, element) => previousValue + element.amount!);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AspectRatio(
          aspectRatio: 1,
          child: PieChart(
            PieChartData(
              borderData: FlBorderData(
                show: false,
              ),
              sectionsSpace: 0,
              centerSpaceRadius: 100,
              sections: _sections
                  .map((e) => PieChartSectionData(
                        color: e.color,
                        value: e.amount,
                        showTitle: false,
                        badgeWidget: SizedBox.square(
                          dimension: 48,
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(999),
                              boxShadow: kElevationToShadow[1],
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              '${((e.amount / _totalAmount) * 100).toStringAsFixed(1)}%',
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ),
                        badgePositionPercentageOffset: 1.2,
                      ))
                  .toList(),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
          child: Wrap(
            spacing: 16,
            runSpacing: 8,
            alignment: WrapAlignment.spaceAround,
            children: _sections
                .map((e) => Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox.square(
                          dimension: 12,
                          child: Container(
                            decoration: BoxDecoration(
                              color: e.color,
                              borderRadius: BorderRadius.circular(999),
                            ),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(left: 8),
                          child: Text(e.category.name),
                        ),
                      ],
                    ))
                .toList(),
          ),
        ),
      ],
    );
  }
}

class _Section {
  final Color color;
  final entities.Category category;
  final double amount;

  _Section({
    required this.color,
    required this.category,
    required this.amount,
  });
}
