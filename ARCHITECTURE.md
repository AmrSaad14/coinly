# Coinly Architecture

## Overview

Coinly uses a simple **three-layer architecture** that balances simplicity with maintainability. This approach is pragmatic and easy to understand while still providing good separation of concerns.

## Architecture Layers

```
┌─────────────────────────────────────────┐
│            🎨 UI Layer                  │
│  Pages, Widgets, User Interface         │
└─────────────────────────────────────────┘
                  ↓
┌─────────────────────────────────────────┐
│          🧠 Logic Layer                 │
│  BLoC, Events, States, Business Logic   │
└─────────────────────────────────────────┘
                  ↓
┌─────────────────────────────────────────┐
│          📦 Data Layer                  │
│  Models, DataSources, Repository        │
└─────────────────────────────────────────┘
```

## 1. Data Layer 📦

**Responsibility**: Handle all data operations

### Components:

#### Models
- Simple data classes with `Equatable`
- JSON serialization (fromJson/toJson)
- No business logic

```dart
class ExampleModel extends Equatable {
  final String id;
  final String title;
  
  const ExampleModel({required this.id, required this.title});
  
  factory ExampleModel.fromJson(Map<String, dynamic> json) {
    return ExampleModel(
      id: json['id'],
      title: json['title'],
    );
  }
  
  Map<String, dynamic> toJson() => {'id': id, 'title': title};
  
  @override
  List<Object> get props => [id, title];
}
```

#### Data Sources
- **Remote**: API calls using Dio
- **Local**: Cache using SharedPreferences

```dart
class ExampleRemoteDataSource {
  final Dio dio;
  
  Future<List<ExampleModel>> getExamples() async {
    final response = await dio.get('/examples');
    return (response.data as List)
        .map((json) => ExampleModel.fromJson(json))
        .toList();
  }
}
```

#### Repository
- Coordinates between remote and local data sources
- Handles online/offline logic
- Returns `Either<Failure, Data>` for error handling

```dart
class ExampleRepository {
  final ExampleRemoteDataSource remoteDataSource;
  final ExampleLocalDataSource localDataSource;
  final NetworkInfo networkInfo;
  
  Future<Either<Failure, List<ExampleModel>>> getExamples() async {
    if (await networkInfo.isConnected) {
      try {
        final data = await remoteDataSource.getExamples();
        await localDataSource.cacheExamples(data);
        return Right(data);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      }
    } else {
      try {
        final cached = await localDataSource.getCachedExamples();
        return Right(cached);
      } on CacheException catch (e) {
        return Left(CacheFailure(e.message));
      }
    }
  }
}
```

## 2. Logic Layer 🧠

**Responsibility**: Manage state and business logic

### Components:

#### Events
- User actions
- System triggers

```dart
abstract class ExampleEvent extends Equatable {
  const ExampleEvent();
}

class LoadExamplesEvent extends ExampleEvent {
  @override
  List<Object> get props => [];
}
```

#### States
- Different UI states
- Contain necessary data

```dart
abstract class ExampleState extends Equatable {
  const ExampleState();
}

class ExampleInitial extends ExampleState {
  @override
  List<Object> get props => [];
}

class ExampleLoading extends ExampleState {
  @override
  List<Object> get props => [];
}

class ExampleLoaded extends ExampleState {
  final List<ExampleModel> examples;
  const ExampleLoaded({required this.examples});
  
  @override
  List<Object> get props => [examples];
}

class ExampleError extends ExampleState {
  final String message;
  const ExampleError({required this.message});
  
  @override
  List<Object> get props => [message];
}
```

#### BLoC
- Receives events
- Processes business logic
- Emits states

```dart
class ExampleBloc extends Bloc<ExampleEvent, ExampleState> {
  final ExampleRepository repository;
  
  ExampleBloc({required this.repository}) : super(ExampleInitial()) {
    on<LoadExamplesEvent>(_onLoadExamples);
  }
  
  Future<void> _onLoadExamples(
    LoadExamplesEvent event,
    Emitter<ExampleState> emit,
  ) async {
    emit(ExampleLoading());
    
    final result = await repository.getExamples();
    
    result.fold(
      (failure) => emit(ExampleError(message: failure.message)),
      (examples) => emit(ExampleLoaded(examples: examples)),
    );
  }
}
```

## 3. UI Layer 🎨

**Responsibility**: Display data and handle user interaction

### Components:

#### Pages
- Full-screen views
- Contains BlocProvider
- Routes to other pages

```dart
class ExamplePage extends StatelessWidget {
  const ExamplePage({super.key});
  
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<ExampleBloc>()..add(LoadExamplesEvent()),
      child: Scaffold(
        appBar: AppBar(title: const Text('Examples')),
        body: BlocBuilder<ExampleBloc, ExampleState>(
          builder: (context, state) {
            if (state is ExampleLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            
            if (state is ExampleLoaded) {
              return ExampleListWidget(examples: state.examples);
            }
            
            if (state is ExampleError) {
              return Center(child: Text(state.message));
            }
            
            return const SizedBox();
          },
        ),
      ),
    );
  }
}
```

#### Widgets
- Reusable UI components
- Presentational only
- No business logic

```dart
class ExampleListWidget extends StatelessWidget {
  final List<ExampleModel> examples;
  
  const ExampleListWidget({super.key, required this.examples});
  
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: examples.length,
      itemBuilder: (context, index) {
        final example = examples[index];
        return ListTile(
          title: Text(example.title),
          subtitle: Text(example.description),
        );
      },
    );
  }
}
```

## Data Flow

### User Action to UI Update

```
1. User Interaction
   ↓
2. UI triggers Event
   example_page.dart: context.read<ExampleBloc>().add(LoadExamplesEvent())
   ↓
3. BLoC receives Event
   example_bloc.dart: on<LoadExamplesEvent>()
   ↓
4. BLoC calls Repository
   repository.getExamples()
   ↓
5. Repository checks Network
   ├─ Online → Remote DataSource → API
   └─ Offline → Local DataSource → Cache
   ↓
6. Repository returns Either<Failure, Data>
   ↓
7. BLoC processes result
   result.fold(
     (failure) => emit(ExampleError()),
     (data) => emit(ExampleLoaded()),
   )
   ↓
8. BLoC emits new State
   ↓
9. UI rebuilds
   BlocBuilder receives new state and rebuilds widgets
   ↓
10. User sees updated UI
```

## Folder Structure

```
lib/
├── core/
│   ├── di/
│   │   └── injection_container.dart    # Dependency registration
│   ├── errors/
│   │   ├── exceptions.dart             # Custom exceptions
│   │   └── failures.dart               # Failure classes
│   ├── network/
│   │   └── network_info.dart           # Network connectivity
│   ├── theme/
│   │   ├── app_theme.dart              # App themes
│   │   └── app_colors.dart             # Color palette
│   └── utils/
│       └── constants.dart              # App constants
│
├── features/
│   └── example/
│       ├── data/
│       │   ├── datasources/
│       │   │   ├── example_remote_data_source.dart
│       │   │   └── example_local_data_source.dart
│       │   ├── models/
│       │   │   └── example_model.dart
│       │   └── repository/
│       │       └── example_repository.dart
│       ├── logic/
│       │   ├── example_bloc.dart
│       │   ├── example_event.dart
│       │   └── example_state.dart
│       └── ui/
│           ├── pages/
│           │   └── example_page.dart
│           └── widgets/
│               └── example_list_widget.dart
│
└── main.dart
```

## Key Principles

### 1. Separation of Concerns
Each layer has a specific responsibility:
- **Data**: Fetch and store data
- **Logic**: Process business rules and manage state
- **UI**: Display and interact

### 2. Unidirectional Data Flow
Data flows in one direction: UI → Logic → Data
States flow back: Data → Logic → UI

### 3. Dependency Rule
- UI depends on Logic
- Logic depends on Data
- Data depends only on Core

### 4. Error Handling
Use `Either<Failure, Success>` pattern:
```dart
// In repository
Future<Either<Failure, Data>> getData() async {
  try {
    final data = await dataSource.fetch();
    return Right(data);
  } on Exception catch (e) {
    return Left(ServerFailure(e.toString()));
  }
}

// In BLoC
result.fold(
  (failure) => emit(ErrorState(failure.message)),
  (data) => emit(LoadedState(data)),
);
```

### 5. State Management
Use BLoC pattern for predictable state:
- Events trigger actions
- BLoC processes logic
- States update UI

## Benefits of This Architecture

✅ **Simple**: Only three layers, easy to understand
✅ **Pragmatic**: No over-engineering, practical approach
✅ **Testable**: Each layer can be tested independently
✅ **Maintainable**: Clear separation makes changes easier
✅ **Scalable**: Easy to add new features
✅ **Type-Safe**: Leverages Dart's type system
✅ **Error-Friendly**: Either pattern for safe error handling

## Comparison with Clean Architecture

This architecture simplifies Clean Architecture by:
- ❌ **No Domain Layer**: No separate entities/use cases/repository interfaces
- ✅ **Direct Repository**: BLoC calls Repository directly
- ✅ **Models as Entities**: No entity-model duplication
- ✅ **Simpler DI**: Less abstraction, more concrete types

**Trade-off**: Less abstraction = simpler code but slightly less flexible for huge apps.
**Good for**: Most apps, small to large teams, rapid development.

## Testing Strategy

### Data Layer
```dart
test('should return data when call is successful', () async {
  // Mock data source
  when(mockRemoteDataSource.getData())
      .thenAnswer((_) async => [testModel]);
  
  // Call repository
  final result = await repository.getData();
  
  // Verify
  expect(result, Right([testModel]));
});
```

### Logic Layer
```dart
blocTest<ExampleBloc, ExampleState>(
  'emits [Loading, Loaded] when data is fetched successfully',
  build: () {
    when(mockRepository.getExamples())
        .thenAnswer((_) async => Right([testModel]));
    return ExampleBloc(repository: mockRepository);
  },
  act: (bloc) => bloc.add(LoadExamplesEvent()),
  expect: () => [
    ExampleLoading(),
    ExampleLoaded(examples: [testModel]),
  ],
);
```

### UI Layer
```dart
testWidgets('displays loading indicator', (tester) async {
  when(() => mockBloc.state).thenReturn(ExampleLoading());
  
  await tester.pumpWidget(makeTestableWidget(ExamplePage()));
  
  expect(find.byType(CircularProgressIndicator), findsOneWidget);
});
```

---

**This architecture provides a perfect balance between simplicity and structure for most Flutter applications.**

