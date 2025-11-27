import 'package:equatable/equatable.dart';

class MarketDetailsResponseModel extends Equatable {
  final MarketDetailsModel data;

  const MarketDetailsResponseModel({required this.data});

  factory MarketDetailsResponseModel.fromJson(Map<String, dynamic> json) {
    return MarketDetailsResponseModel(
      data: MarketDetailsModel.fromJson(json['data'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() {
    return {'data': data.toJson()};
  }

  @override
  List<Object?> get props => [data];
}

class MarketDetailsModel extends Equatable {
  final int id;
  final String name;
  final int? selectedWorkerId;
  final List<MarketWorkerModel> workersList;
  final MarketStatsModel stats;
  final List<MarketChartPointModel> chartData;
  final List<MarketGoalModel> goals;

  const MarketDetailsModel({
    required this.id,
    required this.name,
    required this.selectedWorkerId,
    required this.workersList,
    required this.stats,
    required this.chartData,
    required this.goals,
  });

  factory MarketDetailsModel.fromJson(Map<String, dynamic> json) {
    return MarketDetailsModel(
      id: (json['id'] as num?)?.toInt() ?? 0,
      name: json['name'] as String? ?? '',
      selectedWorkerId: (json['selected_worker_id'] as num?)?.toInt(),
      workersList: (json['workers_list'] as List<dynamic>? ?? [])
          .map(
            (item) => MarketWorkerModel.fromJson(item as Map<String, dynamic>),
          )
          .toList(),
      stats: MarketStatsModel.fromJson(
        json['stats'] as Map<String, dynamic>? ?? const {},
      ),
      chartData: (json['chart_data'] as List<dynamic>? ?? [])
          .map(
            (item) =>
                MarketChartPointModel.fromJson(item as Map<String, dynamic>),
          )
          .toList(),
      goals: (json['goals'] as List<dynamic>? ?? [])
          .map((item) => MarketGoalModel.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'selected_worker_id': selectedWorkerId,
      'workers_list': workersList.map((w) => w.toJson()).toList(),
      'stats': stats.toJson(),
      'chart_data': chartData.map((c) => c.toJson()).toList(),
      'goals': goals.map((g) => g.toJson()).toList(),
    };
  }

  @override
  List<Object?> get props => [
    id,
    name,
    selectedWorkerId,
    workersList,
    stats,
    chartData,
    goals,
  ];
}

class MarketStatsModel extends Equatable {
  final int totalBalance;
  final int totalProfit;
  final int dueAmount;

  const MarketStatsModel({
    this.totalBalance = 0,
    this.totalProfit = 0,
    this.dueAmount = 0,
  });

  factory MarketStatsModel.fromJson(Map<String, dynamic> json) {
    return MarketStatsModel(
      totalBalance: (json['total_balance'] as num?)?.toInt() ?? 0,
      totalProfit: (json['total_profit'] as num?)?.toInt() ?? 0,
      dueAmount: (json['due_amount'] as num?)?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'total_balance': totalBalance,
      'total_profit': totalProfit,
      'due_amount': dueAmount,
    };
  }

  @override
  List<Object?> get props => [totalBalance, totalProfit, dueAmount];
}

class MarketChartPointModel extends Equatable {
  final String label;
  final int value;

  const MarketChartPointModel({required this.label, required this.value});

  factory MarketChartPointModel.fromJson(Map<String, dynamic> json) {
    return MarketChartPointModel(
      label: json['label'] as String? ?? '',
      value: (json['value'] as num?)?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {'label': label, 'value': value};
  }

  @override
  List<Object?> get props => [label, value];
}

class MarketWorkerModel extends Equatable {
  final int id;
  final String name;
  final bool isActive;

  const MarketWorkerModel({
    required this.id,
    required this.name,
    required this.isActive,
  });

  factory MarketWorkerModel.fromJson(Map<String, dynamic> json) {
    return MarketWorkerModel(
      id: (json['id'] as num?)?.toInt() ?? 0,
      name: json['name'] as String? ?? '',
      isActive:
          (json['is_active'] as bool?) ??
          (json['status']?.toString().toLowerCase() == 'active'),
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name, 'is_active': isActive};
  }

  @override
  List<Object?> get props => [id, name, isActive];
}

class MarketGoalModel extends Equatable {
  final int id;
  final String title;
  final int target;
  final int progress;
  final int? workerId;
  final String? workerName;

  const MarketGoalModel({
    this.id = 0,
    this.title = '',
    this.target = 0,
    this.progress = 0,
    this.workerId,
    this.workerName,
  });

  factory MarketGoalModel.fromJson(Map<String, dynamic> json) {
    return MarketGoalModel(
      id: (json['id'] as num?)?.toInt() ?? 0,
      title: json['title'] as String? ?? '',
      target: (json['target'] as num?)?.toInt() ?? 0,
      progress: (json['progress'] as num?)?.toInt() ?? 0,
      workerId: (json['worker_id'] as num?)?.toInt(),
      workerName: json['worker_name'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'target': target,
      'progress': progress,
      if (workerId != null) 'worker_id': workerId,
      if (workerName != null) 'worker_name': workerName,
    };
  }

  @override
  List<Object?> get props => [
    id,
    title,
    target,
    progress,
    workerId,
    workerName,
  ];
}
