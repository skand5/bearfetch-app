// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $ChildProfilesTable extends ChildProfiles
    with TableInfo<$ChildProfilesTable, ChildProfile> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ChildProfilesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _parentIdMeta = const VerificationMeta(
    'parentId',
  );
  @override
  late final GeneratedColumn<String> parentId = GeneratedColumn<String>(
    'parent_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _displayNameMeta = const VerificationMeta(
    'displayName',
  );
  @override
  late final GeneratedColumn<String> displayName = GeneratedColumn<String>(
    'display_name',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isDeletedMeta = const VerificationMeta(
    'isDeleted',
  );
  @override
  late final GeneratedColumn<bool> isDeleted = GeneratedColumn<bool>(
    'is_deleted',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_deleted" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    parentId,
    displayName,
    createdAt,
    isDeleted,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'child_profiles';
  @override
  VerificationContext validateIntegrity(
    Insertable<ChildProfile> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('parent_id')) {
      context.handle(
        _parentIdMeta,
        parentId.isAcceptableOrUnknown(data['parent_id']!, _parentIdMeta),
      );
    }
    if (data.containsKey('display_name')) {
      context.handle(
        _displayNameMeta,
        displayName.isAcceptableOrUnknown(
          data['display_name']!,
          _displayNameMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('is_deleted')) {
      context.handle(
        _isDeletedMeta,
        isDeleted.isAcceptableOrUnknown(data['is_deleted']!, _isDeletedMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ChildProfile map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ChildProfile(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      parentId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}parent_id'],
      ),
      displayName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}display_name'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      isDeleted: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_deleted'],
      )!,
    );
  }

  @override
  $ChildProfilesTable createAlias(String alias) {
    return $ChildProfilesTable(attachedDatabase, alias);
  }
}

class ChildProfile extends DataClass implements Insertable<ChildProfile> {
  final String id;
  final String? parentId;
  final String? displayName;
  final DateTime createdAt;
  final bool isDeleted;
  const ChildProfile({
    required this.id,
    this.parentId,
    this.displayName,
    required this.createdAt,
    required this.isDeleted,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    if (!nullToAbsent || parentId != null) {
      map['parent_id'] = Variable<String>(parentId);
    }
    if (!nullToAbsent || displayName != null) {
      map['display_name'] = Variable<String>(displayName);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['is_deleted'] = Variable<bool>(isDeleted);
    return map;
  }

  ChildProfilesCompanion toCompanion(bool nullToAbsent) {
    return ChildProfilesCompanion(
      id: Value(id),
      parentId: parentId == null && nullToAbsent
          ? const Value.absent()
          : Value(parentId),
      displayName: displayName == null && nullToAbsent
          ? const Value.absent()
          : Value(displayName),
      createdAt: Value(createdAt),
      isDeleted: Value(isDeleted),
    );
  }

  factory ChildProfile.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ChildProfile(
      id: serializer.fromJson<String>(json['id']),
      parentId: serializer.fromJson<String?>(json['parentId']),
      displayName: serializer.fromJson<String?>(json['displayName']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      isDeleted: serializer.fromJson<bool>(json['isDeleted']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'parentId': serializer.toJson<String?>(parentId),
      'displayName': serializer.toJson<String?>(displayName),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'isDeleted': serializer.toJson<bool>(isDeleted),
    };
  }

  ChildProfile copyWith({
    String? id,
    Value<String?> parentId = const Value.absent(),
    Value<String?> displayName = const Value.absent(),
    DateTime? createdAt,
    bool? isDeleted,
  }) => ChildProfile(
    id: id ?? this.id,
    parentId: parentId.present ? parentId.value : this.parentId,
    displayName: displayName.present ? displayName.value : this.displayName,
    createdAt: createdAt ?? this.createdAt,
    isDeleted: isDeleted ?? this.isDeleted,
  );
  ChildProfile copyWithCompanion(ChildProfilesCompanion data) {
    return ChildProfile(
      id: data.id.present ? data.id.value : this.id,
      parentId: data.parentId.present ? data.parentId.value : this.parentId,
      displayName: data.displayName.present
          ? data.displayName.value
          : this.displayName,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      isDeleted: data.isDeleted.present ? data.isDeleted.value : this.isDeleted,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ChildProfile(')
          ..write('id: $id, ')
          ..write('parentId: $parentId, ')
          ..write('displayName: $displayName, ')
          ..write('createdAt: $createdAt, ')
          ..write('isDeleted: $isDeleted')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, parentId, displayName, createdAt, isDeleted);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ChildProfile &&
          other.id == this.id &&
          other.parentId == this.parentId &&
          other.displayName == this.displayName &&
          other.createdAt == this.createdAt &&
          other.isDeleted == this.isDeleted);
}

class ChildProfilesCompanion extends UpdateCompanion<ChildProfile> {
  final Value<String> id;
  final Value<String?> parentId;
  final Value<String?> displayName;
  final Value<DateTime> createdAt;
  final Value<bool> isDeleted;
  final Value<int> rowid;
  const ChildProfilesCompanion({
    this.id = const Value.absent(),
    this.parentId = const Value.absent(),
    this.displayName = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.isDeleted = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ChildProfilesCompanion.insert({
    required String id,
    this.parentId = const Value.absent(),
    this.displayName = const Value.absent(),
    required DateTime createdAt,
    this.isDeleted = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       createdAt = Value(createdAt);
  static Insertable<ChildProfile> custom({
    Expression<String>? id,
    Expression<String>? parentId,
    Expression<String>? displayName,
    Expression<DateTime>? createdAt,
    Expression<bool>? isDeleted,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (parentId != null) 'parent_id': parentId,
      if (displayName != null) 'display_name': displayName,
      if (createdAt != null) 'created_at': createdAt,
      if (isDeleted != null) 'is_deleted': isDeleted,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ChildProfilesCompanion copyWith({
    Value<String>? id,
    Value<String?>? parentId,
    Value<String?>? displayName,
    Value<DateTime>? createdAt,
    Value<bool>? isDeleted,
    Value<int>? rowid,
  }) {
    return ChildProfilesCompanion(
      id: id ?? this.id,
      parentId: parentId ?? this.parentId,
      displayName: displayName ?? this.displayName,
      createdAt: createdAt ?? this.createdAt,
      isDeleted: isDeleted ?? this.isDeleted,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (parentId.present) {
      map['parent_id'] = Variable<String>(parentId.value);
    }
    if (displayName.present) {
      map['display_name'] = Variable<String>(displayName.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (isDeleted.present) {
      map['is_deleted'] = Variable<bool>(isDeleted.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ChildProfilesCompanion(')
          ..write('id: $id, ')
          ..write('parentId: $parentId, ')
          ..write('displayName: $displayName, ')
          ..write('createdAt: $createdAt, ')
          ..write('isDeleted: $isDeleted, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ActivityProgressTable extends ActivityProgress
    with TableInfo<$ActivityProgressTable, ActivityProgressData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ActivityProgressTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _childIdMeta = const VerificationMeta(
    'childId',
  );
  @override
  late final GeneratedColumn<String> childId = GeneratedColumn<String>(
    'child_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _activityIdMeta = const VerificationMeta(
    'activityId',
  );
  @override
  late final GeneratedColumn<String> activityId = GeneratedColumn<String>(
    'activity_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _completedAtMeta = const VerificationMeta(
    'completedAt',
  );
  @override
  late final GeneratedColumn<DateTime> completedAt = GeneratedColumn<DateTime>(
    'completed_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _retryCountMeta = const VerificationMeta(
    'retryCount',
  );
  @override
  late final GeneratedColumn<int> retryCount = GeneratedColumn<int>(
    'retry_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _firstAnswerJsonMeta = const VerificationMeta(
    'firstAnswerJson',
  );
  @override
  late final GeneratedColumn<String> firstAnswerJson = GeneratedColumn<String>(
    'first_answer_json',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    childId,
    activityId,
    completedAt,
    retryCount,
    firstAnswerJson,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'activity_progress';
  @override
  VerificationContext validateIntegrity(
    Insertable<ActivityProgressData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('child_id')) {
      context.handle(
        _childIdMeta,
        childId.isAcceptableOrUnknown(data['child_id']!, _childIdMeta),
      );
    } else if (isInserting) {
      context.missing(_childIdMeta);
    }
    if (data.containsKey('activity_id')) {
      context.handle(
        _activityIdMeta,
        activityId.isAcceptableOrUnknown(data['activity_id']!, _activityIdMeta),
      );
    } else if (isInserting) {
      context.missing(_activityIdMeta);
    }
    if (data.containsKey('completed_at')) {
      context.handle(
        _completedAtMeta,
        completedAt.isAcceptableOrUnknown(
          data['completed_at']!,
          _completedAtMeta,
        ),
      );
    }
    if (data.containsKey('retry_count')) {
      context.handle(
        _retryCountMeta,
        retryCount.isAcceptableOrUnknown(data['retry_count']!, _retryCountMeta),
      );
    }
    if (data.containsKey('first_answer_json')) {
      context.handle(
        _firstAnswerJsonMeta,
        firstAnswerJson.isAcceptableOrUnknown(
          data['first_answer_json']!,
          _firstAnswerJsonMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {childId, activityId};
  @override
  ActivityProgressData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ActivityProgressData(
      childId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}child_id'],
      )!,
      activityId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}activity_id'],
      )!,
      completedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}completed_at'],
      ),
      retryCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}retry_count'],
      )!,
      firstAnswerJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}first_answer_json'],
      ),
    );
  }

  @override
  $ActivityProgressTable createAlias(String alias) {
    return $ActivityProgressTable(attachedDatabase, alias);
  }
}

class ActivityProgressData extends DataClass
    implements Insertable<ActivityProgressData> {
  final String childId;
  final String activityId;
  final DateTime? completedAt;
  final int retryCount;
  final String? firstAnswerJson;
  const ActivityProgressData({
    required this.childId,
    required this.activityId,
    this.completedAt,
    required this.retryCount,
    this.firstAnswerJson,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['child_id'] = Variable<String>(childId);
    map['activity_id'] = Variable<String>(activityId);
    if (!nullToAbsent || completedAt != null) {
      map['completed_at'] = Variable<DateTime>(completedAt);
    }
    map['retry_count'] = Variable<int>(retryCount);
    if (!nullToAbsent || firstAnswerJson != null) {
      map['first_answer_json'] = Variable<String>(firstAnswerJson);
    }
    return map;
  }

  ActivityProgressCompanion toCompanion(bool nullToAbsent) {
    return ActivityProgressCompanion(
      childId: Value(childId),
      activityId: Value(activityId),
      completedAt: completedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(completedAt),
      retryCount: Value(retryCount),
      firstAnswerJson: firstAnswerJson == null && nullToAbsent
          ? const Value.absent()
          : Value(firstAnswerJson),
    );
  }

  factory ActivityProgressData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ActivityProgressData(
      childId: serializer.fromJson<String>(json['childId']),
      activityId: serializer.fromJson<String>(json['activityId']),
      completedAt: serializer.fromJson<DateTime?>(json['completedAt']),
      retryCount: serializer.fromJson<int>(json['retryCount']),
      firstAnswerJson: serializer.fromJson<String?>(json['firstAnswerJson']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'childId': serializer.toJson<String>(childId),
      'activityId': serializer.toJson<String>(activityId),
      'completedAt': serializer.toJson<DateTime?>(completedAt),
      'retryCount': serializer.toJson<int>(retryCount),
      'firstAnswerJson': serializer.toJson<String?>(firstAnswerJson),
    };
  }

  ActivityProgressData copyWith({
    String? childId,
    String? activityId,
    Value<DateTime?> completedAt = const Value.absent(),
    int? retryCount,
    Value<String?> firstAnswerJson = const Value.absent(),
  }) => ActivityProgressData(
    childId: childId ?? this.childId,
    activityId: activityId ?? this.activityId,
    completedAt: completedAt.present ? completedAt.value : this.completedAt,
    retryCount: retryCount ?? this.retryCount,
    firstAnswerJson: firstAnswerJson.present
        ? firstAnswerJson.value
        : this.firstAnswerJson,
  );
  ActivityProgressData copyWithCompanion(ActivityProgressCompanion data) {
    return ActivityProgressData(
      childId: data.childId.present ? data.childId.value : this.childId,
      activityId: data.activityId.present
          ? data.activityId.value
          : this.activityId,
      completedAt: data.completedAt.present
          ? data.completedAt.value
          : this.completedAt,
      retryCount: data.retryCount.present
          ? data.retryCount.value
          : this.retryCount,
      firstAnswerJson: data.firstAnswerJson.present
          ? data.firstAnswerJson.value
          : this.firstAnswerJson,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ActivityProgressData(')
          ..write('childId: $childId, ')
          ..write('activityId: $activityId, ')
          ..write('completedAt: $completedAt, ')
          ..write('retryCount: $retryCount, ')
          ..write('firstAnswerJson: $firstAnswerJson')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    childId,
    activityId,
    completedAt,
    retryCount,
    firstAnswerJson,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ActivityProgressData &&
          other.childId == this.childId &&
          other.activityId == this.activityId &&
          other.completedAt == this.completedAt &&
          other.retryCount == this.retryCount &&
          other.firstAnswerJson == this.firstAnswerJson);
}

class ActivityProgressCompanion extends UpdateCompanion<ActivityProgressData> {
  final Value<String> childId;
  final Value<String> activityId;
  final Value<DateTime?> completedAt;
  final Value<int> retryCount;
  final Value<String?> firstAnswerJson;
  final Value<int> rowid;
  const ActivityProgressCompanion({
    this.childId = const Value.absent(),
    this.activityId = const Value.absent(),
    this.completedAt = const Value.absent(),
    this.retryCount = const Value.absent(),
    this.firstAnswerJson = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ActivityProgressCompanion.insert({
    required String childId,
    required String activityId,
    this.completedAt = const Value.absent(),
    this.retryCount = const Value.absent(),
    this.firstAnswerJson = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : childId = Value(childId),
       activityId = Value(activityId);
  static Insertable<ActivityProgressData> custom({
    Expression<String>? childId,
    Expression<String>? activityId,
    Expression<DateTime>? completedAt,
    Expression<int>? retryCount,
    Expression<String>? firstAnswerJson,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (childId != null) 'child_id': childId,
      if (activityId != null) 'activity_id': activityId,
      if (completedAt != null) 'completed_at': completedAt,
      if (retryCount != null) 'retry_count': retryCount,
      if (firstAnswerJson != null) 'first_answer_json': firstAnswerJson,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ActivityProgressCompanion copyWith({
    Value<String>? childId,
    Value<String>? activityId,
    Value<DateTime?>? completedAt,
    Value<int>? retryCount,
    Value<String?>? firstAnswerJson,
    Value<int>? rowid,
  }) {
    return ActivityProgressCompanion(
      childId: childId ?? this.childId,
      activityId: activityId ?? this.activityId,
      completedAt: completedAt ?? this.completedAt,
      retryCount: retryCount ?? this.retryCount,
      firstAnswerJson: firstAnswerJson ?? this.firstAnswerJson,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (childId.present) {
      map['child_id'] = Variable<String>(childId.value);
    }
    if (activityId.present) {
      map['activity_id'] = Variable<String>(activityId.value);
    }
    if (completedAt.present) {
      map['completed_at'] = Variable<DateTime>(completedAt.value);
    }
    if (retryCount.present) {
      map['retry_count'] = Variable<int>(retryCount.value);
    }
    if (firstAnswerJson.present) {
      map['first_answer_json'] = Variable<String>(firstAnswerJson.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ActivityProgressCompanion(')
          ..write('childId: $childId, ')
          ..write('activityId: $activityId, ')
          ..write('completedAt: $completedAt, ')
          ..write('retryCount: $retryCount, ')
          ..write('firstAnswerJson: $firstAnswerJson, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $RewardTransactionsTable extends RewardTransactions
    with TableInfo<$RewardTransactionsTable, RewardTransaction> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RewardTransactionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _childIdMeta = const VerificationMeta(
    'childId',
  );
  @override
  late final GeneratedColumn<String> childId = GeneratedColumn<String>(
    'child_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _kindMeta = const VerificationMeta('kind');
  @override
  late final GeneratedColumn<String> kind = GeneratedColumn<String>(
    'kind',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _amountMeta = const VerificationMeta('amount');
  @override
  late final GeneratedColumn<int> amount = GeneratedColumn<int>(
    'amount',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _activityIdMeta = const VerificationMeta(
    'activityId',
  );
  @override
  late final GeneratedColumn<String> activityId = GeneratedColumn<String>(
    'activity_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _itemIdMeta = const VerificationMeta('itemId');
  @override
  late final GeneratedColumn<String> itemId = GeneratedColumn<String>(
    'item_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _occurredAtMeta = const VerificationMeta(
    'occurredAt',
  );
  @override
  late final GeneratedColumn<DateTime> occurredAt = GeneratedColumn<DateTime>(
    'occurred_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    childId,
    kind,
    amount,
    activityId,
    itemId,
    occurredAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'reward_transactions';
  @override
  VerificationContext validateIntegrity(
    Insertable<RewardTransaction> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('child_id')) {
      context.handle(
        _childIdMeta,
        childId.isAcceptableOrUnknown(data['child_id']!, _childIdMeta),
      );
    } else if (isInserting) {
      context.missing(_childIdMeta);
    }
    if (data.containsKey('kind')) {
      context.handle(
        _kindMeta,
        kind.isAcceptableOrUnknown(data['kind']!, _kindMeta),
      );
    } else if (isInserting) {
      context.missing(_kindMeta);
    }
    if (data.containsKey('amount')) {
      context.handle(
        _amountMeta,
        amount.isAcceptableOrUnknown(data['amount']!, _amountMeta),
      );
    } else if (isInserting) {
      context.missing(_amountMeta);
    }
    if (data.containsKey('activity_id')) {
      context.handle(
        _activityIdMeta,
        activityId.isAcceptableOrUnknown(data['activity_id']!, _activityIdMeta),
      );
    }
    if (data.containsKey('item_id')) {
      context.handle(
        _itemIdMeta,
        itemId.isAcceptableOrUnknown(data['item_id']!, _itemIdMeta),
      );
    }
    if (data.containsKey('occurred_at')) {
      context.handle(
        _occurredAtMeta,
        occurredAt.isAcceptableOrUnknown(data['occurred_at']!, _occurredAtMeta),
      );
    } else if (isInserting) {
      context.missing(_occurredAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  RewardTransaction map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return RewardTransaction(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      childId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}child_id'],
      )!,
      kind: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}kind'],
      )!,
      amount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}amount'],
      )!,
      activityId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}activity_id'],
      ),
      itemId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}item_id'],
      ),
      occurredAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}occurred_at'],
      )!,
    );
  }

  @override
  $RewardTransactionsTable createAlias(String alias) {
    return $RewardTransactionsTable(attachedDatabase, alias);
  }
}

class RewardTransaction extends DataClass
    implements Insertable<RewardTransaction> {
  final String id;
  final String childId;
  final String kind;
  final int amount;
  final String? activityId;
  final String? itemId;
  final DateTime occurredAt;
  const RewardTransaction({
    required this.id,
    required this.childId,
    required this.kind,
    required this.amount,
    this.activityId,
    this.itemId,
    required this.occurredAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['child_id'] = Variable<String>(childId);
    map['kind'] = Variable<String>(kind);
    map['amount'] = Variable<int>(amount);
    if (!nullToAbsent || activityId != null) {
      map['activity_id'] = Variable<String>(activityId);
    }
    if (!nullToAbsent || itemId != null) {
      map['item_id'] = Variable<String>(itemId);
    }
    map['occurred_at'] = Variable<DateTime>(occurredAt);
    return map;
  }

  RewardTransactionsCompanion toCompanion(bool nullToAbsent) {
    return RewardTransactionsCompanion(
      id: Value(id),
      childId: Value(childId),
      kind: Value(kind),
      amount: Value(amount),
      activityId: activityId == null && nullToAbsent
          ? const Value.absent()
          : Value(activityId),
      itemId: itemId == null && nullToAbsent
          ? const Value.absent()
          : Value(itemId),
      occurredAt: Value(occurredAt),
    );
  }

  factory RewardTransaction.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return RewardTransaction(
      id: serializer.fromJson<String>(json['id']),
      childId: serializer.fromJson<String>(json['childId']),
      kind: serializer.fromJson<String>(json['kind']),
      amount: serializer.fromJson<int>(json['amount']),
      activityId: serializer.fromJson<String?>(json['activityId']),
      itemId: serializer.fromJson<String?>(json['itemId']),
      occurredAt: serializer.fromJson<DateTime>(json['occurredAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'childId': serializer.toJson<String>(childId),
      'kind': serializer.toJson<String>(kind),
      'amount': serializer.toJson<int>(amount),
      'activityId': serializer.toJson<String?>(activityId),
      'itemId': serializer.toJson<String?>(itemId),
      'occurredAt': serializer.toJson<DateTime>(occurredAt),
    };
  }

  RewardTransaction copyWith({
    String? id,
    String? childId,
    String? kind,
    int? amount,
    Value<String?> activityId = const Value.absent(),
    Value<String?> itemId = const Value.absent(),
    DateTime? occurredAt,
  }) => RewardTransaction(
    id: id ?? this.id,
    childId: childId ?? this.childId,
    kind: kind ?? this.kind,
    amount: amount ?? this.amount,
    activityId: activityId.present ? activityId.value : this.activityId,
    itemId: itemId.present ? itemId.value : this.itemId,
    occurredAt: occurredAt ?? this.occurredAt,
  );
  RewardTransaction copyWithCompanion(RewardTransactionsCompanion data) {
    return RewardTransaction(
      id: data.id.present ? data.id.value : this.id,
      childId: data.childId.present ? data.childId.value : this.childId,
      kind: data.kind.present ? data.kind.value : this.kind,
      amount: data.amount.present ? data.amount.value : this.amount,
      activityId: data.activityId.present
          ? data.activityId.value
          : this.activityId,
      itemId: data.itemId.present ? data.itemId.value : this.itemId,
      occurredAt: data.occurredAt.present
          ? data.occurredAt.value
          : this.occurredAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('RewardTransaction(')
          ..write('id: $id, ')
          ..write('childId: $childId, ')
          ..write('kind: $kind, ')
          ..write('amount: $amount, ')
          ..write('activityId: $activityId, ')
          ..write('itemId: $itemId, ')
          ..write('occurredAt: $occurredAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, childId, kind, amount, activityId, itemId, occurredAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is RewardTransaction &&
          other.id == this.id &&
          other.childId == this.childId &&
          other.kind == this.kind &&
          other.amount == this.amount &&
          other.activityId == this.activityId &&
          other.itemId == this.itemId &&
          other.occurredAt == this.occurredAt);
}

class RewardTransactionsCompanion extends UpdateCompanion<RewardTransaction> {
  final Value<String> id;
  final Value<String> childId;
  final Value<String> kind;
  final Value<int> amount;
  final Value<String?> activityId;
  final Value<String?> itemId;
  final Value<DateTime> occurredAt;
  final Value<int> rowid;
  const RewardTransactionsCompanion({
    this.id = const Value.absent(),
    this.childId = const Value.absent(),
    this.kind = const Value.absent(),
    this.amount = const Value.absent(),
    this.activityId = const Value.absent(),
    this.itemId = const Value.absent(),
    this.occurredAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  RewardTransactionsCompanion.insert({
    required String id,
    required String childId,
    required String kind,
    required int amount,
    this.activityId = const Value.absent(),
    this.itemId = const Value.absent(),
    required DateTime occurredAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       childId = Value(childId),
       kind = Value(kind),
       amount = Value(amount),
       occurredAt = Value(occurredAt);
  static Insertable<RewardTransaction> custom({
    Expression<String>? id,
    Expression<String>? childId,
    Expression<String>? kind,
    Expression<int>? amount,
    Expression<String>? activityId,
    Expression<String>? itemId,
    Expression<DateTime>? occurredAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (childId != null) 'child_id': childId,
      if (kind != null) 'kind': kind,
      if (amount != null) 'amount': amount,
      if (activityId != null) 'activity_id': activityId,
      if (itemId != null) 'item_id': itemId,
      if (occurredAt != null) 'occurred_at': occurredAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  RewardTransactionsCompanion copyWith({
    Value<String>? id,
    Value<String>? childId,
    Value<String>? kind,
    Value<int>? amount,
    Value<String?>? activityId,
    Value<String?>? itemId,
    Value<DateTime>? occurredAt,
    Value<int>? rowid,
  }) {
    return RewardTransactionsCompanion(
      id: id ?? this.id,
      childId: childId ?? this.childId,
      kind: kind ?? this.kind,
      amount: amount ?? this.amount,
      activityId: activityId ?? this.activityId,
      itemId: itemId ?? this.itemId,
      occurredAt: occurredAt ?? this.occurredAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (childId.present) {
      map['child_id'] = Variable<String>(childId.value);
    }
    if (kind.present) {
      map['kind'] = Variable<String>(kind.value);
    }
    if (amount.present) {
      map['amount'] = Variable<int>(amount.value);
    }
    if (activityId.present) {
      map['activity_id'] = Variable<String>(activityId.value);
    }
    if (itemId.present) {
      map['item_id'] = Variable<String>(itemId.value);
    }
    if (occurredAt.present) {
      map['occurred_at'] = Variable<DateTime>(occurredAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RewardTransactionsCompanion(')
          ..write('id: $id, ')
          ..write('childId: $childId, ')
          ..write('kind: $kind, ')
          ..write('amount: $amount, ')
          ..write('activityId: $activityId, ')
          ..write('itemId: $itemId, ')
          ..write('occurredAt: $occurredAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $OwnedAccessoriesTable extends OwnedAccessories
    with TableInfo<$OwnedAccessoriesTable, OwnedAccessory> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $OwnedAccessoriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _childIdMeta = const VerificationMeta(
    'childId',
  );
  @override
  late final GeneratedColumn<String> childId = GeneratedColumn<String>(
    'child_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _accessoryIdMeta = const VerificationMeta(
    'accessoryId',
  );
  @override
  late final GeneratedColumn<String> accessoryId = GeneratedColumn<String>(
    'accessory_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _purchasedAtMeta = const VerificationMeta(
    'purchasedAt',
  );
  @override
  late final GeneratedColumn<DateTime> purchasedAt = GeneratedColumn<DateTime>(
    'purchased_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [childId, accessoryId, purchasedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'owned_accessories';
  @override
  VerificationContext validateIntegrity(
    Insertable<OwnedAccessory> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('child_id')) {
      context.handle(
        _childIdMeta,
        childId.isAcceptableOrUnknown(data['child_id']!, _childIdMeta),
      );
    } else if (isInserting) {
      context.missing(_childIdMeta);
    }
    if (data.containsKey('accessory_id')) {
      context.handle(
        _accessoryIdMeta,
        accessoryId.isAcceptableOrUnknown(
          data['accessory_id']!,
          _accessoryIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_accessoryIdMeta);
    }
    if (data.containsKey('purchased_at')) {
      context.handle(
        _purchasedAtMeta,
        purchasedAt.isAcceptableOrUnknown(
          data['purchased_at']!,
          _purchasedAtMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_purchasedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {childId, accessoryId};
  @override
  OwnedAccessory map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return OwnedAccessory(
      childId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}child_id'],
      )!,
      accessoryId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}accessory_id'],
      )!,
      purchasedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}purchased_at'],
      )!,
    );
  }

  @override
  $OwnedAccessoriesTable createAlias(String alias) {
    return $OwnedAccessoriesTable(attachedDatabase, alias);
  }
}

class OwnedAccessory extends DataClass implements Insertable<OwnedAccessory> {
  final String childId;
  final String accessoryId;
  final DateTime purchasedAt;
  const OwnedAccessory({
    required this.childId,
    required this.accessoryId,
    required this.purchasedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['child_id'] = Variable<String>(childId);
    map['accessory_id'] = Variable<String>(accessoryId);
    map['purchased_at'] = Variable<DateTime>(purchasedAt);
    return map;
  }

  OwnedAccessoriesCompanion toCompanion(bool nullToAbsent) {
    return OwnedAccessoriesCompanion(
      childId: Value(childId),
      accessoryId: Value(accessoryId),
      purchasedAt: Value(purchasedAt),
    );
  }

  factory OwnedAccessory.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return OwnedAccessory(
      childId: serializer.fromJson<String>(json['childId']),
      accessoryId: serializer.fromJson<String>(json['accessoryId']),
      purchasedAt: serializer.fromJson<DateTime>(json['purchasedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'childId': serializer.toJson<String>(childId),
      'accessoryId': serializer.toJson<String>(accessoryId),
      'purchasedAt': serializer.toJson<DateTime>(purchasedAt),
    };
  }

  OwnedAccessory copyWith({
    String? childId,
    String? accessoryId,
    DateTime? purchasedAt,
  }) => OwnedAccessory(
    childId: childId ?? this.childId,
    accessoryId: accessoryId ?? this.accessoryId,
    purchasedAt: purchasedAt ?? this.purchasedAt,
  );
  OwnedAccessory copyWithCompanion(OwnedAccessoriesCompanion data) {
    return OwnedAccessory(
      childId: data.childId.present ? data.childId.value : this.childId,
      accessoryId: data.accessoryId.present
          ? data.accessoryId.value
          : this.accessoryId,
      purchasedAt: data.purchasedAt.present
          ? data.purchasedAt.value
          : this.purchasedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('OwnedAccessory(')
          ..write('childId: $childId, ')
          ..write('accessoryId: $accessoryId, ')
          ..write('purchasedAt: $purchasedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(childId, accessoryId, purchasedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is OwnedAccessory &&
          other.childId == this.childId &&
          other.accessoryId == this.accessoryId &&
          other.purchasedAt == this.purchasedAt);
}

class OwnedAccessoriesCompanion extends UpdateCompanion<OwnedAccessory> {
  final Value<String> childId;
  final Value<String> accessoryId;
  final Value<DateTime> purchasedAt;
  final Value<int> rowid;
  const OwnedAccessoriesCompanion({
    this.childId = const Value.absent(),
    this.accessoryId = const Value.absent(),
    this.purchasedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  OwnedAccessoriesCompanion.insert({
    required String childId,
    required String accessoryId,
    required DateTime purchasedAt,
    this.rowid = const Value.absent(),
  }) : childId = Value(childId),
       accessoryId = Value(accessoryId),
       purchasedAt = Value(purchasedAt);
  static Insertable<OwnedAccessory> custom({
    Expression<String>? childId,
    Expression<String>? accessoryId,
    Expression<DateTime>? purchasedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (childId != null) 'child_id': childId,
      if (accessoryId != null) 'accessory_id': accessoryId,
      if (purchasedAt != null) 'purchased_at': purchasedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  OwnedAccessoriesCompanion copyWith({
    Value<String>? childId,
    Value<String>? accessoryId,
    Value<DateTime>? purchasedAt,
    Value<int>? rowid,
  }) {
    return OwnedAccessoriesCompanion(
      childId: childId ?? this.childId,
      accessoryId: accessoryId ?? this.accessoryId,
      purchasedAt: purchasedAt ?? this.purchasedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (childId.present) {
      map['child_id'] = Variable<String>(childId.value);
    }
    if (accessoryId.present) {
      map['accessory_id'] = Variable<String>(accessoryId.value);
    }
    if (purchasedAt.present) {
      map['purchased_at'] = Variable<DateTime>(purchasedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('OwnedAccessoriesCompanion(')
          ..write('childId: $childId, ')
          ..write('accessoryId: $accessoryId, ')
          ..write('purchasedAt: $purchasedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SyncQueueTable extends SyncQueue
    with TableInfo<$SyncQueueTable, SyncQueueData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SyncQueueTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _operationMeta = const VerificationMeta(
    'operation',
  );
  @override
  late final GeneratedColumn<String> operation = GeneratedColumn<String>(
    'operation',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _payloadJsonMeta = const VerificationMeta(
    'payloadJson',
  );
  @override
  late final GeneratedColumn<String> payloadJson = GeneratedColumn<String>(
    'payload_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _attemptsMeta = const VerificationMeta(
    'attempts',
  );
  @override
  late final GeneratedColumn<int> attempts = GeneratedColumn<int>(
    'attempts',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    operation,
    payloadJson,
    createdAt,
    attempts,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'sync_queue';
  @override
  VerificationContext validateIntegrity(
    Insertable<SyncQueueData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('operation')) {
      context.handle(
        _operationMeta,
        operation.isAcceptableOrUnknown(data['operation']!, _operationMeta),
      );
    } else if (isInserting) {
      context.missing(_operationMeta);
    }
    if (data.containsKey('payload_json')) {
      context.handle(
        _payloadJsonMeta,
        payloadJson.isAcceptableOrUnknown(
          data['payload_json']!,
          _payloadJsonMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_payloadJsonMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('attempts')) {
      context.handle(
        _attemptsMeta,
        attempts.isAcceptableOrUnknown(data['attempts']!, _attemptsMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SyncQueueData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SyncQueueData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      operation: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}operation'],
      )!,
      payloadJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}payload_json'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      attempts: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}attempts'],
      )!,
    );
  }

  @override
  $SyncQueueTable createAlias(String alias) {
    return $SyncQueueTable(attachedDatabase, alias);
  }
}

class SyncQueueData extends DataClass implements Insertable<SyncQueueData> {
  final String id;
  final String operation;
  final String payloadJson;
  final DateTime createdAt;
  final int attempts;
  const SyncQueueData({
    required this.id,
    required this.operation,
    required this.payloadJson,
    required this.createdAt,
    required this.attempts,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['operation'] = Variable<String>(operation);
    map['payload_json'] = Variable<String>(payloadJson);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['attempts'] = Variable<int>(attempts);
    return map;
  }

  SyncQueueCompanion toCompanion(bool nullToAbsent) {
    return SyncQueueCompanion(
      id: Value(id),
      operation: Value(operation),
      payloadJson: Value(payloadJson),
      createdAt: Value(createdAt),
      attempts: Value(attempts),
    );
  }

  factory SyncQueueData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SyncQueueData(
      id: serializer.fromJson<String>(json['id']),
      operation: serializer.fromJson<String>(json['operation']),
      payloadJson: serializer.fromJson<String>(json['payloadJson']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      attempts: serializer.fromJson<int>(json['attempts']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'operation': serializer.toJson<String>(operation),
      'payloadJson': serializer.toJson<String>(payloadJson),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'attempts': serializer.toJson<int>(attempts),
    };
  }

  SyncQueueData copyWith({
    String? id,
    String? operation,
    String? payloadJson,
    DateTime? createdAt,
    int? attempts,
  }) => SyncQueueData(
    id: id ?? this.id,
    operation: operation ?? this.operation,
    payloadJson: payloadJson ?? this.payloadJson,
    createdAt: createdAt ?? this.createdAt,
    attempts: attempts ?? this.attempts,
  );
  SyncQueueData copyWithCompanion(SyncQueueCompanion data) {
    return SyncQueueData(
      id: data.id.present ? data.id.value : this.id,
      operation: data.operation.present ? data.operation.value : this.operation,
      payloadJson: data.payloadJson.present
          ? data.payloadJson.value
          : this.payloadJson,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      attempts: data.attempts.present ? data.attempts.value : this.attempts,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SyncQueueData(')
          ..write('id: $id, ')
          ..write('operation: $operation, ')
          ..write('payloadJson: $payloadJson, ')
          ..write('createdAt: $createdAt, ')
          ..write('attempts: $attempts')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, operation, payloadJson, createdAt, attempts);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SyncQueueData &&
          other.id == this.id &&
          other.operation == this.operation &&
          other.payloadJson == this.payloadJson &&
          other.createdAt == this.createdAt &&
          other.attempts == this.attempts);
}

class SyncQueueCompanion extends UpdateCompanion<SyncQueueData> {
  final Value<String> id;
  final Value<String> operation;
  final Value<String> payloadJson;
  final Value<DateTime> createdAt;
  final Value<int> attempts;
  final Value<int> rowid;
  const SyncQueueCompanion({
    this.id = const Value.absent(),
    this.operation = const Value.absent(),
    this.payloadJson = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.attempts = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SyncQueueCompanion.insert({
    required String id,
    required String operation,
    required String payloadJson,
    required DateTime createdAt,
    this.attempts = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       operation = Value(operation),
       payloadJson = Value(payloadJson),
       createdAt = Value(createdAt);
  static Insertable<SyncQueueData> custom({
    Expression<String>? id,
    Expression<String>? operation,
    Expression<String>? payloadJson,
    Expression<DateTime>? createdAt,
    Expression<int>? attempts,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (operation != null) 'operation': operation,
      if (payloadJson != null) 'payload_json': payloadJson,
      if (createdAt != null) 'created_at': createdAt,
      if (attempts != null) 'attempts': attempts,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SyncQueueCompanion copyWith({
    Value<String>? id,
    Value<String>? operation,
    Value<String>? payloadJson,
    Value<DateTime>? createdAt,
    Value<int>? attempts,
    Value<int>? rowid,
  }) {
    return SyncQueueCompanion(
      id: id ?? this.id,
      operation: operation ?? this.operation,
      payloadJson: payloadJson ?? this.payloadJson,
      createdAt: createdAt ?? this.createdAt,
      attempts: attempts ?? this.attempts,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (operation.present) {
      map['operation'] = Variable<String>(operation.value);
    }
    if (payloadJson.present) {
      map['payload_json'] = Variable<String>(payloadJson.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (attempts.present) {
      map['attempts'] = Variable<int>(attempts.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SyncQueueCompanion(')
          ..write('id: $id, ')
          ..write('operation: $operation, ')
          ..write('payloadJson: $payloadJson, ')
          ..write('createdAt: $createdAt, ')
          ..write('attempts: $attempts, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $ChildProfilesTable childProfiles = $ChildProfilesTable(this);
  late final $ActivityProgressTable activityProgress = $ActivityProgressTable(
    this,
  );
  late final $RewardTransactionsTable rewardTransactions =
      $RewardTransactionsTable(this);
  late final $OwnedAccessoriesTable ownedAccessories = $OwnedAccessoriesTable(
    this,
  );
  late final $SyncQueueTable syncQueue = $SyncQueueTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    childProfiles,
    activityProgress,
    rewardTransactions,
    ownedAccessories,
    syncQueue,
  ];
}

typedef $$ChildProfilesTableCreateCompanionBuilder =
    ChildProfilesCompanion Function({
      required String id,
      Value<String?> parentId,
      Value<String?> displayName,
      required DateTime createdAt,
      Value<bool> isDeleted,
      Value<int> rowid,
    });
typedef $$ChildProfilesTableUpdateCompanionBuilder =
    ChildProfilesCompanion Function({
      Value<String> id,
      Value<String?> parentId,
      Value<String?> displayName,
      Value<DateTime> createdAt,
      Value<bool> isDeleted,
      Value<int> rowid,
    });

class $$ChildProfilesTableFilterComposer
    extends Composer<_$AppDatabase, $ChildProfilesTable> {
  $$ChildProfilesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get parentId => $composableBuilder(
    column: $table.parentId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get displayName => $composableBuilder(
    column: $table.displayName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isDeleted => $composableBuilder(
    column: $table.isDeleted,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ChildProfilesTableOrderingComposer
    extends Composer<_$AppDatabase, $ChildProfilesTable> {
  $$ChildProfilesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get parentId => $composableBuilder(
    column: $table.parentId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get displayName => $composableBuilder(
    column: $table.displayName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isDeleted => $composableBuilder(
    column: $table.isDeleted,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ChildProfilesTableAnnotationComposer
    extends Composer<_$AppDatabase, $ChildProfilesTable> {
  $$ChildProfilesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get parentId =>
      $composableBuilder(column: $table.parentId, builder: (column) => column);

  GeneratedColumn<String> get displayName => $composableBuilder(
    column: $table.displayName,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<bool> get isDeleted =>
      $composableBuilder(column: $table.isDeleted, builder: (column) => column);
}

class $$ChildProfilesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ChildProfilesTable,
          ChildProfile,
          $$ChildProfilesTableFilterComposer,
          $$ChildProfilesTableOrderingComposer,
          $$ChildProfilesTableAnnotationComposer,
          $$ChildProfilesTableCreateCompanionBuilder,
          $$ChildProfilesTableUpdateCompanionBuilder,
          (
            ChildProfile,
            BaseReferences<_$AppDatabase, $ChildProfilesTable, ChildProfile>,
          ),
          ChildProfile,
          PrefetchHooks Function()
        > {
  $$ChildProfilesTableTableManager(_$AppDatabase db, $ChildProfilesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ChildProfilesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ChildProfilesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ChildProfilesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String?> parentId = const Value.absent(),
                Value<String?> displayName = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<bool> isDeleted = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ChildProfilesCompanion(
                id: id,
                parentId: parentId,
                displayName: displayName,
                createdAt: createdAt,
                isDeleted: isDeleted,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                Value<String?> parentId = const Value.absent(),
                Value<String?> displayName = const Value.absent(),
                required DateTime createdAt,
                Value<bool> isDeleted = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ChildProfilesCompanion.insert(
                id: id,
                parentId: parentId,
                displayName: displayName,
                createdAt: createdAt,
                isDeleted: isDeleted,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ChildProfilesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ChildProfilesTable,
      ChildProfile,
      $$ChildProfilesTableFilterComposer,
      $$ChildProfilesTableOrderingComposer,
      $$ChildProfilesTableAnnotationComposer,
      $$ChildProfilesTableCreateCompanionBuilder,
      $$ChildProfilesTableUpdateCompanionBuilder,
      (
        ChildProfile,
        BaseReferences<_$AppDatabase, $ChildProfilesTable, ChildProfile>,
      ),
      ChildProfile,
      PrefetchHooks Function()
    >;
typedef $$ActivityProgressTableCreateCompanionBuilder =
    ActivityProgressCompanion Function({
      required String childId,
      required String activityId,
      Value<DateTime?> completedAt,
      Value<int> retryCount,
      Value<String?> firstAnswerJson,
      Value<int> rowid,
    });
typedef $$ActivityProgressTableUpdateCompanionBuilder =
    ActivityProgressCompanion Function({
      Value<String> childId,
      Value<String> activityId,
      Value<DateTime?> completedAt,
      Value<int> retryCount,
      Value<String?> firstAnswerJson,
      Value<int> rowid,
    });

class $$ActivityProgressTableFilterComposer
    extends Composer<_$AppDatabase, $ActivityProgressTable> {
  $$ActivityProgressTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get childId => $composableBuilder(
    column: $table.childId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get activityId => $composableBuilder(
    column: $table.activityId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get completedAt => $composableBuilder(
    column: $table.completedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get retryCount => $composableBuilder(
    column: $table.retryCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get firstAnswerJson => $composableBuilder(
    column: $table.firstAnswerJson,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ActivityProgressTableOrderingComposer
    extends Composer<_$AppDatabase, $ActivityProgressTable> {
  $$ActivityProgressTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get childId => $composableBuilder(
    column: $table.childId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get activityId => $composableBuilder(
    column: $table.activityId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get completedAt => $composableBuilder(
    column: $table.completedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get retryCount => $composableBuilder(
    column: $table.retryCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get firstAnswerJson => $composableBuilder(
    column: $table.firstAnswerJson,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ActivityProgressTableAnnotationComposer
    extends Composer<_$AppDatabase, $ActivityProgressTable> {
  $$ActivityProgressTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get childId =>
      $composableBuilder(column: $table.childId, builder: (column) => column);

  GeneratedColumn<String> get activityId => $composableBuilder(
    column: $table.activityId,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get completedAt => $composableBuilder(
    column: $table.completedAt,
    builder: (column) => column,
  );

  GeneratedColumn<int> get retryCount => $composableBuilder(
    column: $table.retryCount,
    builder: (column) => column,
  );

  GeneratedColumn<String> get firstAnswerJson => $composableBuilder(
    column: $table.firstAnswerJson,
    builder: (column) => column,
  );
}

class $$ActivityProgressTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ActivityProgressTable,
          ActivityProgressData,
          $$ActivityProgressTableFilterComposer,
          $$ActivityProgressTableOrderingComposer,
          $$ActivityProgressTableAnnotationComposer,
          $$ActivityProgressTableCreateCompanionBuilder,
          $$ActivityProgressTableUpdateCompanionBuilder,
          (
            ActivityProgressData,
            BaseReferences<
              _$AppDatabase,
              $ActivityProgressTable,
              ActivityProgressData
            >,
          ),
          ActivityProgressData,
          PrefetchHooks Function()
        > {
  $$ActivityProgressTableTableManager(
    _$AppDatabase db,
    $ActivityProgressTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ActivityProgressTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ActivityProgressTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ActivityProgressTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> childId = const Value.absent(),
                Value<String> activityId = const Value.absent(),
                Value<DateTime?> completedAt = const Value.absent(),
                Value<int> retryCount = const Value.absent(),
                Value<String?> firstAnswerJson = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ActivityProgressCompanion(
                childId: childId,
                activityId: activityId,
                completedAt: completedAt,
                retryCount: retryCount,
                firstAnswerJson: firstAnswerJson,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String childId,
                required String activityId,
                Value<DateTime?> completedAt = const Value.absent(),
                Value<int> retryCount = const Value.absent(),
                Value<String?> firstAnswerJson = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ActivityProgressCompanion.insert(
                childId: childId,
                activityId: activityId,
                completedAt: completedAt,
                retryCount: retryCount,
                firstAnswerJson: firstAnswerJson,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ActivityProgressTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ActivityProgressTable,
      ActivityProgressData,
      $$ActivityProgressTableFilterComposer,
      $$ActivityProgressTableOrderingComposer,
      $$ActivityProgressTableAnnotationComposer,
      $$ActivityProgressTableCreateCompanionBuilder,
      $$ActivityProgressTableUpdateCompanionBuilder,
      (
        ActivityProgressData,
        BaseReferences<
          _$AppDatabase,
          $ActivityProgressTable,
          ActivityProgressData
        >,
      ),
      ActivityProgressData,
      PrefetchHooks Function()
    >;
typedef $$RewardTransactionsTableCreateCompanionBuilder =
    RewardTransactionsCompanion Function({
      required String id,
      required String childId,
      required String kind,
      required int amount,
      Value<String?> activityId,
      Value<String?> itemId,
      required DateTime occurredAt,
      Value<int> rowid,
    });
typedef $$RewardTransactionsTableUpdateCompanionBuilder =
    RewardTransactionsCompanion Function({
      Value<String> id,
      Value<String> childId,
      Value<String> kind,
      Value<int> amount,
      Value<String?> activityId,
      Value<String?> itemId,
      Value<DateTime> occurredAt,
      Value<int> rowid,
    });

class $$RewardTransactionsTableFilterComposer
    extends Composer<_$AppDatabase, $RewardTransactionsTable> {
  $$RewardTransactionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get childId => $composableBuilder(
    column: $table.childId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get kind => $composableBuilder(
    column: $table.kind,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get amount => $composableBuilder(
    column: $table.amount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get activityId => $composableBuilder(
    column: $table.activityId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get itemId => $composableBuilder(
    column: $table.itemId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get occurredAt => $composableBuilder(
    column: $table.occurredAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$RewardTransactionsTableOrderingComposer
    extends Composer<_$AppDatabase, $RewardTransactionsTable> {
  $$RewardTransactionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get childId => $composableBuilder(
    column: $table.childId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get kind => $composableBuilder(
    column: $table.kind,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get amount => $composableBuilder(
    column: $table.amount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get activityId => $composableBuilder(
    column: $table.activityId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get itemId => $composableBuilder(
    column: $table.itemId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get occurredAt => $composableBuilder(
    column: $table.occurredAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$RewardTransactionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $RewardTransactionsTable> {
  $$RewardTransactionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get childId =>
      $composableBuilder(column: $table.childId, builder: (column) => column);

  GeneratedColumn<String> get kind =>
      $composableBuilder(column: $table.kind, builder: (column) => column);

  GeneratedColumn<int> get amount =>
      $composableBuilder(column: $table.amount, builder: (column) => column);

  GeneratedColumn<String> get activityId => $composableBuilder(
    column: $table.activityId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get itemId =>
      $composableBuilder(column: $table.itemId, builder: (column) => column);

  GeneratedColumn<DateTime> get occurredAt => $composableBuilder(
    column: $table.occurredAt,
    builder: (column) => column,
  );
}

class $$RewardTransactionsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $RewardTransactionsTable,
          RewardTransaction,
          $$RewardTransactionsTableFilterComposer,
          $$RewardTransactionsTableOrderingComposer,
          $$RewardTransactionsTableAnnotationComposer,
          $$RewardTransactionsTableCreateCompanionBuilder,
          $$RewardTransactionsTableUpdateCompanionBuilder,
          (
            RewardTransaction,
            BaseReferences<
              _$AppDatabase,
              $RewardTransactionsTable,
              RewardTransaction
            >,
          ),
          RewardTransaction,
          PrefetchHooks Function()
        > {
  $$RewardTransactionsTableTableManager(
    _$AppDatabase db,
    $RewardTransactionsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RewardTransactionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$RewardTransactionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$RewardTransactionsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> childId = const Value.absent(),
                Value<String> kind = const Value.absent(),
                Value<int> amount = const Value.absent(),
                Value<String?> activityId = const Value.absent(),
                Value<String?> itemId = const Value.absent(),
                Value<DateTime> occurredAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => RewardTransactionsCompanion(
                id: id,
                childId: childId,
                kind: kind,
                amount: amount,
                activityId: activityId,
                itemId: itemId,
                occurredAt: occurredAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String childId,
                required String kind,
                required int amount,
                Value<String?> activityId = const Value.absent(),
                Value<String?> itemId = const Value.absent(),
                required DateTime occurredAt,
                Value<int> rowid = const Value.absent(),
              }) => RewardTransactionsCompanion.insert(
                id: id,
                childId: childId,
                kind: kind,
                amount: amount,
                activityId: activityId,
                itemId: itemId,
                occurredAt: occurredAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$RewardTransactionsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $RewardTransactionsTable,
      RewardTransaction,
      $$RewardTransactionsTableFilterComposer,
      $$RewardTransactionsTableOrderingComposer,
      $$RewardTransactionsTableAnnotationComposer,
      $$RewardTransactionsTableCreateCompanionBuilder,
      $$RewardTransactionsTableUpdateCompanionBuilder,
      (
        RewardTransaction,
        BaseReferences<
          _$AppDatabase,
          $RewardTransactionsTable,
          RewardTransaction
        >,
      ),
      RewardTransaction,
      PrefetchHooks Function()
    >;
typedef $$OwnedAccessoriesTableCreateCompanionBuilder =
    OwnedAccessoriesCompanion Function({
      required String childId,
      required String accessoryId,
      required DateTime purchasedAt,
      Value<int> rowid,
    });
typedef $$OwnedAccessoriesTableUpdateCompanionBuilder =
    OwnedAccessoriesCompanion Function({
      Value<String> childId,
      Value<String> accessoryId,
      Value<DateTime> purchasedAt,
      Value<int> rowid,
    });

class $$OwnedAccessoriesTableFilterComposer
    extends Composer<_$AppDatabase, $OwnedAccessoriesTable> {
  $$OwnedAccessoriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get childId => $composableBuilder(
    column: $table.childId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get accessoryId => $composableBuilder(
    column: $table.accessoryId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get purchasedAt => $composableBuilder(
    column: $table.purchasedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$OwnedAccessoriesTableOrderingComposer
    extends Composer<_$AppDatabase, $OwnedAccessoriesTable> {
  $$OwnedAccessoriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get childId => $composableBuilder(
    column: $table.childId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get accessoryId => $composableBuilder(
    column: $table.accessoryId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get purchasedAt => $composableBuilder(
    column: $table.purchasedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$OwnedAccessoriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $OwnedAccessoriesTable> {
  $$OwnedAccessoriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get childId =>
      $composableBuilder(column: $table.childId, builder: (column) => column);

  GeneratedColumn<String> get accessoryId => $composableBuilder(
    column: $table.accessoryId,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get purchasedAt => $composableBuilder(
    column: $table.purchasedAt,
    builder: (column) => column,
  );
}

class $$OwnedAccessoriesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $OwnedAccessoriesTable,
          OwnedAccessory,
          $$OwnedAccessoriesTableFilterComposer,
          $$OwnedAccessoriesTableOrderingComposer,
          $$OwnedAccessoriesTableAnnotationComposer,
          $$OwnedAccessoriesTableCreateCompanionBuilder,
          $$OwnedAccessoriesTableUpdateCompanionBuilder,
          (
            OwnedAccessory,
            BaseReferences<
              _$AppDatabase,
              $OwnedAccessoriesTable,
              OwnedAccessory
            >,
          ),
          OwnedAccessory,
          PrefetchHooks Function()
        > {
  $$OwnedAccessoriesTableTableManager(
    _$AppDatabase db,
    $OwnedAccessoriesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$OwnedAccessoriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$OwnedAccessoriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$OwnedAccessoriesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> childId = const Value.absent(),
                Value<String> accessoryId = const Value.absent(),
                Value<DateTime> purchasedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => OwnedAccessoriesCompanion(
                childId: childId,
                accessoryId: accessoryId,
                purchasedAt: purchasedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String childId,
                required String accessoryId,
                required DateTime purchasedAt,
                Value<int> rowid = const Value.absent(),
              }) => OwnedAccessoriesCompanion.insert(
                childId: childId,
                accessoryId: accessoryId,
                purchasedAt: purchasedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$OwnedAccessoriesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $OwnedAccessoriesTable,
      OwnedAccessory,
      $$OwnedAccessoriesTableFilterComposer,
      $$OwnedAccessoriesTableOrderingComposer,
      $$OwnedAccessoriesTableAnnotationComposer,
      $$OwnedAccessoriesTableCreateCompanionBuilder,
      $$OwnedAccessoriesTableUpdateCompanionBuilder,
      (
        OwnedAccessory,
        BaseReferences<_$AppDatabase, $OwnedAccessoriesTable, OwnedAccessory>,
      ),
      OwnedAccessory,
      PrefetchHooks Function()
    >;
typedef $$SyncQueueTableCreateCompanionBuilder =
    SyncQueueCompanion Function({
      required String id,
      required String operation,
      required String payloadJson,
      required DateTime createdAt,
      Value<int> attempts,
      Value<int> rowid,
    });
typedef $$SyncQueueTableUpdateCompanionBuilder =
    SyncQueueCompanion Function({
      Value<String> id,
      Value<String> operation,
      Value<String> payloadJson,
      Value<DateTime> createdAt,
      Value<int> attempts,
      Value<int> rowid,
    });

class $$SyncQueueTableFilterComposer
    extends Composer<_$AppDatabase, $SyncQueueTable> {
  $$SyncQueueTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get operation => $composableBuilder(
    column: $table.operation,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get payloadJson => $composableBuilder(
    column: $table.payloadJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get attempts => $composableBuilder(
    column: $table.attempts,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SyncQueueTableOrderingComposer
    extends Composer<_$AppDatabase, $SyncQueueTable> {
  $$SyncQueueTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get operation => $composableBuilder(
    column: $table.operation,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get payloadJson => $composableBuilder(
    column: $table.payloadJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get attempts => $composableBuilder(
    column: $table.attempts,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SyncQueueTableAnnotationComposer
    extends Composer<_$AppDatabase, $SyncQueueTable> {
  $$SyncQueueTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get operation =>
      $composableBuilder(column: $table.operation, builder: (column) => column);

  GeneratedColumn<String> get payloadJson => $composableBuilder(
    column: $table.payloadJson,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<int> get attempts =>
      $composableBuilder(column: $table.attempts, builder: (column) => column);
}

class $$SyncQueueTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SyncQueueTable,
          SyncQueueData,
          $$SyncQueueTableFilterComposer,
          $$SyncQueueTableOrderingComposer,
          $$SyncQueueTableAnnotationComposer,
          $$SyncQueueTableCreateCompanionBuilder,
          $$SyncQueueTableUpdateCompanionBuilder,
          (
            SyncQueueData,
            BaseReferences<_$AppDatabase, $SyncQueueTable, SyncQueueData>,
          ),
          SyncQueueData,
          PrefetchHooks Function()
        > {
  $$SyncQueueTableTableManager(_$AppDatabase db, $SyncQueueTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SyncQueueTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SyncQueueTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SyncQueueTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> operation = const Value.absent(),
                Value<String> payloadJson = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> attempts = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SyncQueueCompanion(
                id: id,
                operation: operation,
                payloadJson: payloadJson,
                createdAt: createdAt,
                attempts: attempts,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String operation,
                required String payloadJson,
                required DateTime createdAt,
                Value<int> attempts = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SyncQueueCompanion.insert(
                id: id,
                operation: operation,
                payloadJson: payloadJson,
                createdAt: createdAt,
                attempts: attempts,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SyncQueueTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SyncQueueTable,
      SyncQueueData,
      $$SyncQueueTableFilterComposer,
      $$SyncQueueTableOrderingComposer,
      $$SyncQueueTableAnnotationComposer,
      $$SyncQueueTableCreateCompanionBuilder,
      $$SyncQueueTableUpdateCompanionBuilder,
      (
        SyncQueueData,
        BaseReferences<_$AppDatabase, $SyncQueueTable, SyncQueueData>,
      ),
      SyncQueueData,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$ChildProfilesTableTableManager get childProfiles =>
      $$ChildProfilesTableTableManager(_db, _db.childProfiles);
  $$ActivityProgressTableTableManager get activityProgress =>
      $$ActivityProgressTableTableManager(_db, _db.activityProgress);
  $$RewardTransactionsTableTableManager get rewardTransactions =>
      $$RewardTransactionsTableTableManager(_db, _db.rewardTransactions);
  $$OwnedAccessoriesTableTableManager get ownedAccessories =>
      $$OwnedAccessoriesTableTableManager(_db, _db.ownedAccessories);
  $$SyncQueueTableTableManager get syncQueue =>
      $$SyncQueueTableTableManager(_db, _db.syncQueue);
}
