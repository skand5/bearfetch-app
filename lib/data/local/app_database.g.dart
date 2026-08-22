// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $ParentProfilesTable extends ParentProfiles
    with TableInfo<$ParentProfilesTable, ParentProfile> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ParentProfilesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _authUserIdMeta = const VerificationMeta(
    'authUserId',
  );
  @override
  late final GeneratedColumn<String> authUserId = GeneratedColumn<String>(
    'auth_user_id',
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
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    authUserId,
    displayName,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'parent_profiles';
  @override
  VerificationContext validateIntegrity(
    Insertable<ParentProfile> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('auth_user_id')) {
      context.handle(
        _authUserIdMeta,
        authUserId.isAcceptableOrUnknown(
          data['auth_user_id']!,
          _authUserIdMeta,
        ),
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
    } else if (isInserting) {
      context.missing(_displayNameMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ParentProfile map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ParentProfile(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      authUserId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}auth_user_id'],
      ),
      displayName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}display_name'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $ParentProfilesTable createAlias(String alias) {
    return $ParentProfilesTable(attachedDatabase, alias);
  }
}

class ParentProfile extends DataClass implements Insertable<ParentProfile> {
  final String id;
  final String? authUserId;
  final String displayName;
  final DateTime createdAt;
  final DateTime updatedAt;
  const ParentProfile({
    required this.id,
    this.authUserId,
    required this.displayName,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    if (!nullToAbsent || authUserId != null) {
      map['auth_user_id'] = Variable<String>(authUserId);
    }
    map['display_name'] = Variable<String>(displayName);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  ParentProfilesCompanion toCompanion(bool nullToAbsent) {
    return ParentProfilesCompanion(
      id: Value(id),
      authUserId: authUserId == null && nullToAbsent
          ? const Value.absent()
          : Value(authUserId),
      displayName: Value(displayName),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory ParentProfile.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ParentProfile(
      id: serializer.fromJson<String>(json['id']),
      authUserId: serializer.fromJson<String?>(json['authUserId']),
      displayName: serializer.fromJson<String>(json['displayName']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'authUserId': serializer.toJson<String?>(authUserId),
      'displayName': serializer.toJson<String>(displayName),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  ParentProfile copyWith({
    String? id,
    Value<String?> authUserId = const Value.absent(),
    String? displayName,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => ParentProfile(
    id: id ?? this.id,
    authUserId: authUserId.present ? authUserId.value : this.authUserId,
    displayName: displayName ?? this.displayName,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  ParentProfile copyWithCompanion(ParentProfilesCompanion data) {
    return ParentProfile(
      id: data.id.present ? data.id.value : this.id,
      authUserId: data.authUserId.present
          ? data.authUserId.value
          : this.authUserId,
      displayName: data.displayName.present
          ? data.displayName.value
          : this.displayName,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ParentProfile(')
          ..write('id: $id, ')
          ..write('authUserId: $authUserId, ')
          ..write('displayName: $displayName, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, authUserId, displayName, createdAt, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ParentProfile &&
          other.id == this.id &&
          other.authUserId == this.authUserId &&
          other.displayName == this.displayName &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class ParentProfilesCompanion extends UpdateCompanion<ParentProfile> {
  final Value<String> id;
  final Value<String?> authUserId;
  final Value<String> displayName;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const ParentProfilesCompanion({
    this.id = const Value.absent(),
    this.authUserId = const Value.absent(),
    this.displayName = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ParentProfilesCompanion.insert({
    required String id,
    this.authUserId = const Value.absent(),
    required String displayName,
    required DateTime createdAt,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       displayName = Value(displayName),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<ParentProfile> custom({
    Expression<String>? id,
    Expression<String>? authUserId,
    Expression<String>? displayName,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (authUserId != null) 'auth_user_id': authUserId,
      if (displayName != null) 'display_name': displayName,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ParentProfilesCompanion copyWith({
    Value<String>? id,
    Value<String?>? authUserId,
    Value<String>? displayName,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return ParentProfilesCompanion(
      id: id ?? this.id,
      authUserId: authUserId ?? this.authUserId,
      displayName: displayName ?? this.displayName,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (authUserId.present) {
      map['auth_user_id'] = Variable<String>(authUserId.value);
    }
    if (displayName.present) {
      map['display_name'] = Variable<String>(displayName.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ParentProfilesCompanion(')
          ..write('id: $id, ')
          ..write('authUserId: $authUserId, ')
          ..write('displayName: $displayName, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ConsentRecordsTable extends ConsentRecords
    with TableInfo<$ConsentRecordsTable, ConsentRecord> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ConsentRecordsTable(this.attachedDatabase, [this._alias]);
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
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _versionMeta = const VerificationMeta(
    'version',
  );
  @override
  late final GeneratedColumn<String> version = GeneratedColumn<String>(
    'version',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _consentedAtMeta = const VerificationMeta(
    'consentedAt',
  );
  @override
  late final GeneratedColumn<DateTime> consentedAt = GeneratedColumn<DateTime>(
    'consented_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _withdrawnAtMeta = const VerificationMeta(
    'withdrawnAt',
  );
  @override
  late final GeneratedColumn<DateTime> withdrawnAt = GeneratedColumn<DateTime>(
    'withdrawn_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
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
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    parentId,
    status,
    version,
    consentedAt,
    withdrawnAt,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'consent_records';
  @override
  VerificationContext validateIntegrity(
    Insertable<ConsentRecord> instance, {
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
    } else if (isInserting) {
      context.missing(_parentIdMeta);
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    } else if (isInserting) {
      context.missing(_statusMeta);
    }
    if (data.containsKey('version')) {
      context.handle(
        _versionMeta,
        version.isAcceptableOrUnknown(data['version']!, _versionMeta),
      );
    }
    if (data.containsKey('consented_at')) {
      context.handle(
        _consentedAtMeta,
        consentedAt.isAcceptableOrUnknown(
          data['consented_at']!,
          _consentedAtMeta,
        ),
      );
    }
    if (data.containsKey('withdrawn_at')) {
      context.handle(
        _withdrawnAtMeta,
        withdrawnAt.isAcceptableOrUnknown(
          data['withdrawn_at']!,
          _withdrawnAtMeta,
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
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ConsentRecord map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ConsentRecord(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      parentId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}parent_id'],
      )!,
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      version: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}version'],
      ),
      consentedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}consented_at'],
      ),
      withdrawnAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}withdrawn_at'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $ConsentRecordsTable createAlias(String alias) {
    return $ConsentRecordsTable(attachedDatabase, alias);
  }
}

class ConsentRecord extends DataClass implements Insertable<ConsentRecord> {
  final String id;
  final String parentId;
  final String status;
  final String? version;
  final DateTime? consentedAt;
  final DateTime? withdrawnAt;
  final DateTime createdAt;
  final DateTime updatedAt;
  const ConsentRecord({
    required this.id,
    required this.parentId,
    required this.status,
    this.version,
    this.consentedAt,
    this.withdrawnAt,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['parent_id'] = Variable<String>(parentId);
    map['status'] = Variable<String>(status);
    if (!nullToAbsent || version != null) {
      map['version'] = Variable<String>(version);
    }
    if (!nullToAbsent || consentedAt != null) {
      map['consented_at'] = Variable<DateTime>(consentedAt);
    }
    if (!nullToAbsent || withdrawnAt != null) {
      map['withdrawn_at'] = Variable<DateTime>(withdrawnAt);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  ConsentRecordsCompanion toCompanion(bool nullToAbsent) {
    return ConsentRecordsCompanion(
      id: Value(id),
      parentId: Value(parentId),
      status: Value(status),
      version: version == null && nullToAbsent
          ? const Value.absent()
          : Value(version),
      consentedAt: consentedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(consentedAt),
      withdrawnAt: withdrawnAt == null && nullToAbsent
          ? const Value.absent()
          : Value(withdrawnAt),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory ConsentRecord.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ConsentRecord(
      id: serializer.fromJson<String>(json['id']),
      parentId: serializer.fromJson<String>(json['parentId']),
      status: serializer.fromJson<String>(json['status']),
      version: serializer.fromJson<String?>(json['version']),
      consentedAt: serializer.fromJson<DateTime?>(json['consentedAt']),
      withdrawnAt: serializer.fromJson<DateTime?>(json['withdrawnAt']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'parentId': serializer.toJson<String>(parentId),
      'status': serializer.toJson<String>(status),
      'version': serializer.toJson<String?>(version),
      'consentedAt': serializer.toJson<DateTime?>(consentedAt),
      'withdrawnAt': serializer.toJson<DateTime?>(withdrawnAt),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  ConsentRecord copyWith({
    String? id,
    String? parentId,
    String? status,
    Value<String?> version = const Value.absent(),
    Value<DateTime?> consentedAt = const Value.absent(),
    Value<DateTime?> withdrawnAt = const Value.absent(),
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => ConsentRecord(
    id: id ?? this.id,
    parentId: parentId ?? this.parentId,
    status: status ?? this.status,
    version: version.present ? version.value : this.version,
    consentedAt: consentedAt.present ? consentedAt.value : this.consentedAt,
    withdrawnAt: withdrawnAt.present ? withdrawnAt.value : this.withdrawnAt,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  ConsentRecord copyWithCompanion(ConsentRecordsCompanion data) {
    return ConsentRecord(
      id: data.id.present ? data.id.value : this.id,
      parentId: data.parentId.present ? data.parentId.value : this.parentId,
      status: data.status.present ? data.status.value : this.status,
      version: data.version.present ? data.version.value : this.version,
      consentedAt: data.consentedAt.present
          ? data.consentedAt.value
          : this.consentedAt,
      withdrawnAt: data.withdrawnAt.present
          ? data.withdrawnAt.value
          : this.withdrawnAt,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ConsentRecord(')
          ..write('id: $id, ')
          ..write('parentId: $parentId, ')
          ..write('status: $status, ')
          ..write('version: $version, ')
          ..write('consentedAt: $consentedAt, ')
          ..write('withdrawnAt: $withdrawnAt, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    parentId,
    status,
    version,
    consentedAt,
    withdrawnAt,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ConsentRecord &&
          other.id == this.id &&
          other.parentId == this.parentId &&
          other.status == this.status &&
          other.version == this.version &&
          other.consentedAt == this.consentedAt &&
          other.withdrawnAt == this.withdrawnAt &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class ConsentRecordsCompanion extends UpdateCompanion<ConsentRecord> {
  final Value<String> id;
  final Value<String> parentId;
  final Value<String> status;
  final Value<String?> version;
  final Value<DateTime?> consentedAt;
  final Value<DateTime?> withdrawnAt;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const ConsentRecordsCompanion({
    this.id = const Value.absent(),
    this.parentId = const Value.absent(),
    this.status = const Value.absent(),
    this.version = const Value.absent(),
    this.consentedAt = const Value.absent(),
    this.withdrawnAt = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ConsentRecordsCompanion.insert({
    required String id,
    required String parentId,
    required String status,
    this.version = const Value.absent(),
    this.consentedAt = const Value.absent(),
    this.withdrawnAt = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       parentId = Value(parentId),
       status = Value(status),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<ConsentRecord> custom({
    Expression<String>? id,
    Expression<String>? parentId,
    Expression<String>? status,
    Expression<String>? version,
    Expression<DateTime>? consentedAt,
    Expression<DateTime>? withdrawnAt,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (parentId != null) 'parent_id': parentId,
      if (status != null) 'status': status,
      if (version != null) 'version': version,
      if (consentedAt != null) 'consented_at': consentedAt,
      if (withdrawnAt != null) 'withdrawn_at': withdrawnAt,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ConsentRecordsCompanion copyWith({
    Value<String>? id,
    Value<String>? parentId,
    Value<String>? status,
    Value<String?>? version,
    Value<DateTime?>? consentedAt,
    Value<DateTime?>? withdrawnAt,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return ConsentRecordsCompanion(
      id: id ?? this.id,
      parentId: parentId ?? this.parentId,
      status: status ?? this.status,
      version: version ?? this.version,
      consentedAt: consentedAt ?? this.consentedAt,
      withdrawnAt: withdrawnAt ?? this.withdrawnAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
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
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (version.present) {
      map['version'] = Variable<String>(version.value);
    }
    if (consentedAt.present) {
      map['consented_at'] = Variable<DateTime>(consentedAt.value);
    }
    if (withdrawnAt.present) {
      map['withdrawn_at'] = Variable<DateTime>(withdrawnAt.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ConsentRecordsCompanion(')
          ..write('id: $id, ')
          ..write('parentId: $parentId, ')
          ..write('status: $status, ')
          ..write('version: $version, ')
          ..write('consentedAt: $consentedAt, ')
          ..write('withdrawnAt: $withdrawnAt, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $LearnerProfilesTable extends LearnerProfiles
    with TableInfo<$LearnerProfilesTable, LearnerProfile> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LearnerProfilesTable(this.attachedDatabase, [this._alias]);
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
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nicknameMeta = const VerificationMeta(
    'nickname',
  );
  @override
  late final GeneratedColumn<String> nickname = GeneratedColumn<String>(
    'nickname',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _avatarIdMeta = const VerificationMeta(
    'avatarId',
  );
  @override
  late final GeneratedColumn<String> avatarId = GeneratedColumn<String>(
    'avatar_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _ageBandMeta = const VerificationMeta(
    'ageBand',
  );
  @override
  late final GeneratedColumn<String> ageBand = GeneratedColumn<String>(
    'age_band',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _languageMeta = const VerificationMeta(
    'language',
  );
  @override
  late final GeneratedColumn<String> language = GeneratedColumn<String>(
    'language',
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
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
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
    nickname,
    avatarId,
    ageBand,
    language,
    createdAt,
    updatedAt,
    isDeleted,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'learner_profiles';
  @override
  VerificationContext validateIntegrity(
    Insertable<LearnerProfile> instance, {
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
    } else if (isInserting) {
      context.missing(_parentIdMeta);
    }
    if (data.containsKey('nickname')) {
      context.handle(
        _nicknameMeta,
        nickname.isAcceptableOrUnknown(data['nickname']!, _nicknameMeta),
      );
    } else if (isInserting) {
      context.missing(_nicknameMeta);
    }
    if (data.containsKey('avatar_id')) {
      context.handle(
        _avatarIdMeta,
        avatarId.isAcceptableOrUnknown(data['avatar_id']!, _avatarIdMeta),
      );
    } else if (isInserting) {
      context.missing(_avatarIdMeta);
    }
    if (data.containsKey('age_band')) {
      context.handle(
        _ageBandMeta,
        ageBand.isAcceptableOrUnknown(data['age_band']!, _ageBandMeta),
      );
    } else if (isInserting) {
      context.missing(_ageBandMeta);
    }
    if (data.containsKey('language')) {
      context.handle(
        _languageMeta,
        language.isAcceptableOrUnknown(data['language']!, _languageMeta),
      );
    } else if (isInserting) {
      context.missing(_languageMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
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
  LearnerProfile map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LearnerProfile(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      parentId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}parent_id'],
      )!,
      nickname: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}nickname'],
      )!,
      avatarId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}avatar_id'],
      )!,
      ageBand: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}age_band'],
      )!,
      language: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}language'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      isDeleted: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_deleted'],
      )!,
    );
  }

  @override
  $LearnerProfilesTable createAlias(String alias) {
    return $LearnerProfilesTable(attachedDatabase, alias);
  }
}

class LearnerProfile extends DataClass implements Insertable<LearnerProfile> {
  final String id;
  final String parentId;
  final String nickname;
  final String avatarId;
  final String ageBand;
  final String language;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool isDeleted;
  const LearnerProfile({
    required this.id,
    required this.parentId,
    required this.nickname,
    required this.avatarId,
    required this.ageBand,
    required this.language,
    required this.createdAt,
    required this.updatedAt,
    required this.isDeleted,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['parent_id'] = Variable<String>(parentId);
    map['nickname'] = Variable<String>(nickname);
    map['avatar_id'] = Variable<String>(avatarId);
    map['age_band'] = Variable<String>(ageBand);
    map['language'] = Variable<String>(language);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    map['is_deleted'] = Variable<bool>(isDeleted);
    return map;
  }

  LearnerProfilesCompanion toCompanion(bool nullToAbsent) {
    return LearnerProfilesCompanion(
      id: Value(id),
      parentId: Value(parentId),
      nickname: Value(nickname),
      avatarId: Value(avatarId),
      ageBand: Value(ageBand),
      language: Value(language),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      isDeleted: Value(isDeleted),
    );
  }

  factory LearnerProfile.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LearnerProfile(
      id: serializer.fromJson<String>(json['id']),
      parentId: serializer.fromJson<String>(json['parentId']),
      nickname: serializer.fromJson<String>(json['nickname']),
      avatarId: serializer.fromJson<String>(json['avatarId']),
      ageBand: serializer.fromJson<String>(json['ageBand']),
      language: serializer.fromJson<String>(json['language']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      isDeleted: serializer.fromJson<bool>(json['isDeleted']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'parentId': serializer.toJson<String>(parentId),
      'nickname': serializer.toJson<String>(nickname),
      'avatarId': serializer.toJson<String>(avatarId),
      'ageBand': serializer.toJson<String>(ageBand),
      'language': serializer.toJson<String>(language),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'isDeleted': serializer.toJson<bool>(isDeleted),
    };
  }

  LearnerProfile copyWith({
    String? id,
    String? parentId,
    String? nickname,
    String? avatarId,
    String? ageBand,
    String? language,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isDeleted,
  }) => LearnerProfile(
    id: id ?? this.id,
    parentId: parentId ?? this.parentId,
    nickname: nickname ?? this.nickname,
    avatarId: avatarId ?? this.avatarId,
    ageBand: ageBand ?? this.ageBand,
    language: language ?? this.language,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    isDeleted: isDeleted ?? this.isDeleted,
  );
  LearnerProfile copyWithCompanion(LearnerProfilesCompanion data) {
    return LearnerProfile(
      id: data.id.present ? data.id.value : this.id,
      parentId: data.parentId.present ? data.parentId.value : this.parentId,
      nickname: data.nickname.present ? data.nickname.value : this.nickname,
      avatarId: data.avatarId.present ? data.avatarId.value : this.avatarId,
      ageBand: data.ageBand.present ? data.ageBand.value : this.ageBand,
      language: data.language.present ? data.language.value : this.language,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      isDeleted: data.isDeleted.present ? data.isDeleted.value : this.isDeleted,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LearnerProfile(')
          ..write('id: $id, ')
          ..write('parentId: $parentId, ')
          ..write('nickname: $nickname, ')
          ..write('avatarId: $avatarId, ')
          ..write('ageBand: $ageBand, ')
          ..write('language: $language, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('isDeleted: $isDeleted')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    parentId,
    nickname,
    avatarId,
    ageBand,
    language,
    createdAt,
    updatedAt,
    isDeleted,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LearnerProfile &&
          other.id == this.id &&
          other.parentId == this.parentId &&
          other.nickname == this.nickname &&
          other.avatarId == this.avatarId &&
          other.ageBand == this.ageBand &&
          other.language == this.language &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.isDeleted == this.isDeleted);
}

class LearnerProfilesCompanion extends UpdateCompanion<LearnerProfile> {
  final Value<String> id;
  final Value<String> parentId;
  final Value<String> nickname;
  final Value<String> avatarId;
  final Value<String> ageBand;
  final Value<String> language;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<bool> isDeleted;
  final Value<int> rowid;
  const LearnerProfilesCompanion({
    this.id = const Value.absent(),
    this.parentId = const Value.absent(),
    this.nickname = const Value.absent(),
    this.avatarId = const Value.absent(),
    this.ageBand = const Value.absent(),
    this.language = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.isDeleted = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  LearnerProfilesCompanion.insert({
    required String id,
    required String parentId,
    required String nickname,
    required String avatarId,
    required String ageBand,
    required String language,
    required DateTime createdAt,
    required DateTime updatedAt,
    this.isDeleted = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       parentId = Value(parentId),
       nickname = Value(nickname),
       avatarId = Value(avatarId),
       ageBand = Value(ageBand),
       language = Value(language),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<LearnerProfile> custom({
    Expression<String>? id,
    Expression<String>? parentId,
    Expression<String>? nickname,
    Expression<String>? avatarId,
    Expression<String>? ageBand,
    Expression<String>? language,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<bool>? isDeleted,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (parentId != null) 'parent_id': parentId,
      if (nickname != null) 'nickname': nickname,
      if (avatarId != null) 'avatar_id': avatarId,
      if (ageBand != null) 'age_band': ageBand,
      if (language != null) 'language': language,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (isDeleted != null) 'is_deleted': isDeleted,
      if (rowid != null) 'rowid': rowid,
    });
  }

  LearnerProfilesCompanion copyWith({
    Value<String>? id,
    Value<String>? parentId,
    Value<String>? nickname,
    Value<String>? avatarId,
    Value<String>? ageBand,
    Value<String>? language,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<bool>? isDeleted,
    Value<int>? rowid,
  }) {
    return LearnerProfilesCompanion(
      id: id ?? this.id,
      parentId: parentId ?? this.parentId,
      nickname: nickname ?? this.nickname,
      avatarId: avatarId ?? this.avatarId,
      ageBand: ageBand ?? this.ageBand,
      language: language ?? this.language,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
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
    if (nickname.present) {
      map['nickname'] = Variable<String>(nickname.value);
    }
    if (avatarId.present) {
      map['avatar_id'] = Variable<String>(avatarId.value);
    }
    if (ageBand.present) {
      map['age_band'] = Variable<String>(ageBand.value);
    }
    if (language.present) {
      map['language'] = Variable<String>(language.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
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
    return (StringBuffer('LearnerProfilesCompanion(')
          ..write('id: $id, ')
          ..write('parentId: $parentId, ')
          ..write('nickname: $nickname, ')
          ..write('avatarId: $avatarId, ')
          ..write('ageBand: $ageBand, ')
          ..write('language: $language, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
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
  static const VerificationMeta _learnerIdMeta = const VerificationMeta(
    'learnerId',
  );
  @override
  late final GeneratedColumn<String> learnerId = GeneratedColumn<String>(
    'learner_id',
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
  @override
  List<GeneratedColumn> get $columns => [
    learnerId,
    activityId,
    completedAt,
    retryCount,
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
    if (data.containsKey('learner_id')) {
      context.handle(
        _learnerIdMeta,
        learnerId.isAcceptableOrUnknown(data['learner_id']!, _learnerIdMeta),
      );
    } else if (isInserting) {
      context.missing(_learnerIdMeta);
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
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {learnerId, activityId};
  @override
  ActivityProgressData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ActivityProgressData(
      learnerId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}learner_id'],
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
    );
  }

  @override
  $ActivityProgressTable createAlias(String alias) {
    return $ActivityProgressTable(attachedDatabase, alias);
  }
}

class ActivityProgressData extends DataClass
    implements Insertable<ActivityProgressData> {
  final String learnerId;
  final String activityId;
  final DateTime? completedAt;
  final int retryCount;
  const ActivityProgressData({
    required this.learnerId,
    required this.activityId,
    this.completedAt,
    required this.retryCount,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['learner_id'] = Variable<String>(learnerId);
    map['activity_id'] = Variable<String>(activityId);
    if (!nullToAbsent || completedAt != null) {
      map['completed_at'] = Variable<DateTime>(completedAt);
    }
    map['retry_count'] = Variable<int>(retryCount);
    return map;
  }

  ActivityProgressCompanion toCompanion(bool nullToAbsent) {
    return ActivityProgressCompanion(
      learnerId: Value(learnerId),
      activityId: Value(activityId),
      completedAt: completedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(completedAt),
      retryCount: Value(retryCount),
    );
  }

  factory ActivityProgressData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ActivityProgressData(
      learnerId: serializer.fromJson<String>(json['learnerId']),
      activityId: serializer.fromJson<String>(json['activityId']),
      completedAt: serializer.fromJson<DateTime?>(json['completedAt']),
      retryCount: serializer.fromJson<int>(json['retryCount']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'learnerId': serializer.toJson<String>(learnerId),
      'activityId': serializer.toJson<String>(activityId),
      'completedAt': serializer.toJson<DateTime?>(completedAt),
      'retryCount': serializer.toJson<int>(retryCount),
    };
  }

  ActivityProgressData copyWith({
    String? learnerId,
    String? activityId,
    Value<DateTime?> completedAt = const Value.absent(),
    int? retryCount,
  }) => ActivityProgressData(
    learnerId: learnerId ?? this.learnerId,
    activityId: activityId ?? this.activityId,
    completedAt: completedAt.present ? completedAt.value : this.completedAt,
    retryCount: retryCount ?? this.retryCount,
  );
  ActivityProgressData copyWithCompanion(ActivityProgressCompanion data) {
    return ActivityProgressData(
      learnerId: data.learnerId.present ? data.learnerId.value : this.learnerId,
      activityId: data.activityId.present
          ? data.activityId.value
          : this.activityId,
      completedAt: data.completedAt.present
          ? data.completedAt.value
          : this.completedAt,
      retryCount: data.retryCount.present
          ? data.retryCount.value
          : this.retryCount,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ActivityProgressData(')
          ..write('learnerId: $learnerId, ')
          ..write('activityId: $activityId, ')
          ..write('completedAt: $completedAt, ')
          ..write('retryCount: $retryCount')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(learnerId, activityId, completedAt, retryCount);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ActivityProgressData &&
          other.learnerId == this.learnerId &&
          other.activityId == this.activityId &&
          other.completedAt == this.completedAt &&
          other.retryCount == this.retryCount);
}

class ActivityProgressCompanion extends UpdateCompanion<ActivityProgressData> {
  final Value<String> learnerId;
  final Value<String> activityId;
  final Value<DateTime?> completedAt;
  final Value<int> retryCount;
  final Value<int> rowid;
  const ActivityProgressCompanion({
    this.learnerId = const Value.absent(),
    this.activityId = const Value.absent(),
    this.completedAt = const Value.absent(),
    this.retryCount = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ActivityProgressCompanion.insert({
    required String learnerId,
    required String activityId,
    this.completedAt = const Value.absent(),
    this.retryCount = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : learnerId = Value(learnerId),
       activityId = Value(activityId);
  static Insertable<ActivityProgressData> custom({
    Expression<String>? learnerId,
    Expression<String>? activityId,
    Expression<DateTime>? completedAt,
    Expression<int>? retryCount,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (learnerId != null) 'learner_id': learnerId,
      if (activityId != null) 'activity_id': activityId,
      if (completedAt != null) 'completed_at': completedAt,
      if (retryCount != null) 'retry_count': retryCount,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ActivityProgressCompanion copyWith({
    Value<String>? learnerId,
    Value<String>? activityId,
    Value<DateTime?>? completedAt,
    Value<int>? retryCount,
    Value<int>? rowid,
  }) {
    return ActivityProgressCompanion(
      learnerId: learnerId ?? this.learnerId,
      activityId: activityId ?? this.activityId,
      completedAt: completedAt ?? this.completedAt,
      retryCount: retryCount ?? this.retryCount,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (learnerId.present) {
      map['learner_id'] = Variable<String>(learnerId.value);
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
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ActivityProgressCompanion(')
          ..write('learnerId: $learnerId, ')
          ..write('activityId: $activityId, ')
          ..write('completedAt: $completedAt, ')
          ..write('retryCount: $retryCount, ')
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
  static const VerificationMeta _learnerIdMeta = const VerificationMeta(
    'learnerId',
  );
  @override
  late final GeneratedColumn<String> learnerId = GeneratedColumn<String>(
    'learner_id',
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
  static const VerificationMeta _reasonTypeMeta = const VerificationMeta(
    'reasonType',
  );
  @override
  late final GeneratedColumn<String> reasonType = GeneratedColumn<String>(
    'reason_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _reasonIdMeta = const VerificationMeta(
    'reasonId',
  );
  @override
  late final GeneratedColumn<String> reasonId = GeneratedColumn<String>(
    'reason_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _idempotencyKeyMeta = const VerificationMeta(
    'idempotencyKey',
  );
  @override
  late final GeneratedColumn<String> idempotencyKey = GeneratedColumn<String>(
    'idempotency_key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
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
    learnerId,
    kind,
    amount,
    reasonType,
    reasonId,
    idempotencyKey,
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
    if (data.containsKey('learner_id')) {
      context.handle(
        _learnerIdMeta,
        learnerId.isAcceptableOrUnknown(data['learner_id']!, _learnerIdMeta),
      );
    } else if (isInserting) {
      context.missing(_learnerIdMeta);
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
    if (data.containsKey('reason_type')) {
      context.handle(
        _reasonTypeMeta,
        reasonType.isAcceptableOrUnknown(data['reason_type']!, _reasonTypeMeta),
      );
    } else if (isInserting) {
      context.missing(_reasonTypeMeta);
    }
    if (data.containsKey('reason_id')) {
      context.handle(
        _reasonIdMeta,
        reasonId.isAcceptableOrUnknown(data['reason_id']!, _reasonIdMeta),
      );
    } else if (isInserting) {
      context.missing(_reasonIdMeta);
    }
    if (data.containsKey('idempotency_key')) {
      context.handle(
        _idempotencyKeyMeta,
        idempotencyKey.isAcceptableOrUnknown(
          data['idempotency_key']!,
          _idempotencyKeyMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_idempotencyKeyMeta);
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
      learnerId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}learner_id'],
      )!,
      kind: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}kind'],
      )!,
      amount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}amount'],
      )!,
      reasonType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}reason_type'],
      )!,
      reasonId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}reason_id'],
      )!,
      idempotencyKey: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}idempotency_key'],
      )!,
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
  final String learnerId;
  final String kind;
  final int amount;
  final String reasonType;
  final String reasonId;
  final String idempotencyKey;
  final DateTime occurredAt;
  const RewardTransaction({
    required this.id,
    required this.learnerId,
    required this.kind,
    required this.amount,
    required this.reasonType,
    required this.reasonId,
    required this.idempotencyKey,
    required this.occurredAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['learner_id'] = Variable<String>(learnerId);
    map['kind'] = Variable<String>(kind);
    map['amount'] = Variable<int>(amount);
    map['reason_type'] = Variable<String>(reasonType);
    map['reason_id'] = Variable<String>(reasonId);
    map['idempotency_key'] = Variable<String>(idempotencyKey);
    map['occurred_at'] = Variable<DateTime>(occurredAt);
    return map;
  }

  RewardTransactionsCompanion toCompanion(bool nullToAbsent) {
    return RewardTransactionsCompanion(
      id: Value(id),
      learnerId: Value(learnerId),
      kind: Value(kind),
      amount: Value(amount),
      reasonType: Value(reasonType),
      reasonId: Value(reasonId),
      idempotencyKey: Value(idempotencyKey),
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
      learnerId: serializer.fromJson<String>(json['learnerId']),
      kind: serializer.fromJson<String>(json['kind']),
      amount: serializer.fromJson<int>(json['amount']),
      reasonType: serializer.fromJson<String>(json['reasonType']),
      reasonId: serializer.fromJson<String>(json['reasonId']),
      idempotencyKey: serializer.fromJson<String>(json['idempotencyKey']),
      occurredAt: serializer.fromJson<DateTime>(json['occurredAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'learnerId': serializer.toJson<String>(learnerId),
      'kind': serializer.toJson<String>(kind),
      'amount': serializer.toJson<int>(amount),
      'reasonType': serializer.toJson<String>(reasonType),
      'reasonId': serializer.toJson<String>(reasonId),
      'idempotencyKey': serializer.toJson<String>(idempotencyKey),
      'occurredAt': serializer.toJson<DateTime>(occurredAt),
    };
  }

  RewardTransaction copyWith({
    String? id,
    String? learnerId,
    String? kind,
    int? amount,
    String? reasonType,
    String? reasonId,
    String? idempotencyKey,
    DateTime? occurredAt,
  }) => RewardTransaction(
    id: id ?? this.id,
    learnerId: learnerId ?? this.learnerId,
    kind: kind ?? this.kind,
    amount: amount ?? this.amount,
    reasonType: reasonType ?? this.reasonType,
    reasonId: reasonId ?? this.reasonId,
    idempotencyKey: idempotencyKey ?? this.idempotencyKey,
    occurredAt: occurredAt ?? this.occurredAt,
  );
  RewardTransaction copyWithCompanion(RewardTransactionsCompanion data) {
    return RewardTransaction(
      id: data.id.present ? data.id.value : this.id,
      learnerId: data.learnerId.present ? data.learnerId.value : this.learnerId,
      kind: data.kind.present ? data.kind.value : this.kind,
      amount: data.amount.present ? data.amount.value : this.amount,
      reasonType: data.reasonType.present
          ? data.reasonType.value
          : this.reasonType,
      reasonId: data.reasonId.present ? data.reasonId.value : this.reasonId,
      idempotencyKey: data.idempotencyKey.present
          ? data.idempotencyKey.value
          : this.idempotencyKey,
      occurredAt: data.occurredAt.present
          ? data.occurredAt.value
          : this.occurredAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('RewardTransaction(')
          ..write('id: $id, ')
          ..write('learnerId: $learnerId, ')
          ..write('kind: $kind, ')
          ..write('amount: $amount, ')
          ..write('reasonType: $reasonType, ')
          ..write('reasonId: $reasonId, ')
          ..write('idempotencyKey: $idempotencyKey, ')
          ..write('occurredAt: $occurredAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    learnerId,
    kind,
    amount,
    reasonType,
    reasonId,
    idempotencyKey,
    occurredAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is RewardTransaction &&
          other.id == this.id &&
          other.learnerId == this.learnerId &&
          other.kind == this.kind &&
          other.amount == this.amount &&
          other.reasonType == this.reasonType &&
          other.reasonId == this.reasonId &&
          other.idempotencyKey == this.idempotencyKey &&
          other.occurredAt == this.occurredAt);
}

class RewardTransactionsCompanion extends UpdateCompanion<RewardTransaction> {
  final Value<String> id;
  final Value<String> learnerId;
  final Value<String> kind;
  final Value<int> amount;
  final Value<String> reasonType;
  final Value<String> reasonId;
  final Value<String> idempotencyKey;
  final Value<DateTime> occurredAt;
  final Value<int> rowid;
  const RewardTransactionsCompanion({
    this.id = const Value.absent(),
    this.learnerId = const Value.absent(),
    this.kind = const Value.absent(),
    this.amount = const Value.absent(),
    this.reasonType = const Value.absent(),
    this.reasonId = const Value.absent(),
    this.idempotencyKey = const Value.absent(),
    this.occurredAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  RewardTransactionsCompanion.insert({
    required String id,
    required String learnerId,
    required String kind,
    required int amount,
    required String reasonType,
    required String reasonId,
    required String idempotencyKey,
    required DateTime occurredAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       learnerId = Value(learnerId),
       kind = Value(kind),
       amount = Value(amount),
       reasonType = Value(reasonType),
       reasonId = Value(reasonId),
       idempotencyKey = Value(idempotencyKey),
       occurredAt = Value(occurredAt);
  static Insertable<RewardTransaction> custom({
    Expression<String>? id,
    Expression<String>? learnerId,
    Expression<String>? kind,
    Expression<int>? amount,
    Expression<String>? reasonType,
    Expression<String>? reasonId,
    Expression<String>? idempotencyKey,
    Expression<DateTime>? occurredAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (learnerId != null) 'learner_id': learnerId,
      if (kind != null) 'kind': kind,
      if (amount != null) 'amount': amount,
      if (reasonType != null) 'reason_type': reasonType,
      if (reasonId != null) 'reason_id': reasonId,
      if (idempotencyKey != null) 'idempotency_key': idempotencyKey,
      if (occurredAt != null) 'occurred_at': occurredAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  RewardTransactionsCompanion copyWith({
    Value<String>? id,
    Value<String>? learnerId,
    Value<String>? kind,
    Value<int>? amount,
    Value<String>? reasonType,
    Value<String>? reasonId,
    Value<String>? idempotencyKey,
    Value<DateTime>? occurredAt,
    Value<int>? rowid,
  }) {
    return RewardTransactionsCompanion(
      id: id ?? this.id,
      learnerId: learnerId ?? this.learnerId,
      kind: kind ?? this.kind,
      amount: amount ?? this.amount,
      reasonType: reasonType ?? this.reasonType,
      reasonId: reasonId ?? this.reasonId,
      idempotencyKey: idempotencyKey ?? this.idempotencyKey,
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
    if (learnerId.present) {
      map['learner_id'] = Variable<String>(learnerId.value);
    }
    if (kind.present) {
      map['kind'] = Variable<String>(kind.value);
    }
    if (amount.present) {
      map['amount'] = Variable<int>(amount.value);
    }
    if (reasonType.present) {
      map['reason_type'] = Variable<String>(reasonType.value);
    }
    if (reasonId.present) {
      map['reason_id'] = Variable<String>(reasonId.value);
    }
    if (idempotencyKey.present) {
      map['idempotency_key'] = Variable<String>(idempotencyKey.value);
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
          ..write('learnerId: $learnerId, ')
          ..write('kind: $kind, ')
          ..write('amount: $amount, ')
          ..write('reasonType: $reasonType, ')
          ..write('reasonId: $reasonId, ')
          ..write('idempotencyKey: $idempotencyKey, ')
          ..write('occurredAt: $occurredAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $AchievementsTable extends Achievements
    with TableInfo<$AchievementsTable, Achievement> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AchievementsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _learnerIdMeta = const VerificationMeta(
    'learnerId',
  );
  @override
  late final GeneratedColumn<String> learnerId = GeneratedColumn<String>(
    'learner_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _achievementIdMeta = const VerificationMeta(
    'achievementId',
  );
  @override
  late final GeneratedColumn<String> achievementId = GeneratedColumn<String>(
    'achievement_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _earnedAtMeta = const VerificationMeta(
    'earnedAt',
  );
  @override
  late final GeneratedColumn<DateTime> earnedAt = GeneratedColumn<DateTime>(
    'earned_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [learnerId, achievementId, earnedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'achievements';
  @override
  VerificationContext validateIntegrity(
    Insertable<Achievement> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('learner_id')) {
      context.handle(
        _learnerIdMeta,
        learnerId.isAcceptableOrUnknown(data['learner_id']!, _learnerIdMeta),
      );
    } else if (isInserting) {
      context.missing(_learnerIdMeta);
    }
    if (data.containsKey('achievement_id')) {
      context.handle(
        _achievementIdMeta,
        achievementId.isAcceptableOrUnknown(
          data['achievement_id']!,
          _achievementIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_achievementIdMeta);
    }
    if (data.containsKey('earned_at')) {
      context.handle(
        _earnedAtMeta,
        earnedAt.isAcceptableOrUnknown(data['earned_at']!, _earnedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_earnedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {learnerId, achievementId};
  @override
  Achievement map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Achievement(
      learnerId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}learner_id'],
      )!,
      achievementId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}achievement_id'],
      )!,
      earnedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}earned_at'],
      )!,
    );
  }

  @override
  $AchievementsTable createAlias(String alias) {
    return $AchievementsTable(attachedDatabase, alias);
  }
}

class Achievement extends DataClass implements Insertable<Achievement> {
  final String learnerId;
  final String achievementId;
  final DateTime earnedAt;
  const Achievement({
    required this.learnerId,
    required this.achievementId,
    required this.earnedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['learner_id'] = Variable<String>(learnerId);
    map['achievement_id'] = Variable<String>(achievementId);
    map['earned_at'] = Variable<DateTime>(earnedAt);
    return map;
  }

  AchievementsCompanion toCompanion(bool nullToAbsent) {
    return AchievementsCompanion(
      learnerId: Value(learnerId),
      achievementId: Value(achievementId),
      earnedAt: Value(earnedAt),
    );
  }

  factory Achievement.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Achievement(
      learnerId: serializer.fromJson<String>(json['learnerId']),
      achievementId: serializer.fromJson<String>(json['achievementId']),
      earnedAt: serializer.fromJson<DateTime>(json['earnedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'learnerId': serializer.toJson<String>(learnerId),
      'achievementId': serializer.toJson<String>(achievementId),
      'earnedAt': serializer.toJson<DateTime>(earnedAt),
    };
  }

  Achievement copyWith({
    String? learnerId,
    String? achievementId,
    DateTime? earnedAt,
  }) => Achievement(
    learnerId: learnerId ?? this.learnerId,
    achievementId: achievementId ?? this.achievementId,
    earnedAt: earnedAt ?? this.earnedAt,
  );
  Achievement copyWithCompanion(AchievementsCompanion data) {
    return Achievement(
      learnerId: data.learnerId.present ? data.learnerId.value : this.learnerId,
      achievementId: data.achievementId.present
          ? data.achievementId.value
          : this.achievementId,
      earnedAt: data.earnedAt.present ? data.earnedAt.value : this.earnedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Achievement(')
          ..write('learnerId: $learnerId, ')
          ..write('achievementId: $achievementId, ')
          ..write('earnedAt: $earnedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(learnerId, achievementId, earnedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Achievement &&
          other.learnerId == this.learnerId &&
          other.achievementId == this.achievementId &&
          other.earnedAt == this.earnedAt);
}

class AchievementsCompanion extends UpdateCompanion<Achievement> {
  final Value<String> learnerId;
  final Value<String> achievementId;
  final Value<DateTime> earnedAt;
  final Value<int> rowid;
  const AchievementsCompanion({
    this.learnerId = const Value.absent(),
    this.achievementId = const Value.absent(),
    this.earnedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  AchievementsCompanion.insert({
    required String learnerId,
    required String achievementId,
    required DateTime earnedAt,
    this.rowid = const Value.absent(),
  }) : learnerId = Value(learnerId),
       achievementId = Value(achievementId),
       earnedAt = Value(earnedAt);
  static Insertable<Achievement> custom({
    Expression<String>? learnerId,
    Expression<String>? achievementId,
    Expression<DateTime>? earnedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (learnerId != null) 'learner_id': learnerId,
      if (achievementId != null) 'achievement_id': achievementId,
      if (earnedAt != null) 'earned_at': earnedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  AchievementsCompanion copyWith({
    Value<String>? learnerId,
    Value<String>? achievementId,
    Value<DateTime>? earnedAt,
    Value<int>? rowid,
  }) {
    return AchievementsCompanion(
      learnerId: learnerId ?? this.learnerId,
      achievementId: achievementId ?? this.achievementId,
      earnedAt: earnedAt ?? this.earnedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (learnerId.present) {
      map['learner_id'] = Variable<String>(learnerId.value);
    }
    if (achievementId.present) {
      map['achievement_id'] = Variable<String>(achievementId.value);
    }
    if (earnedAt.present) {
      map['earned_at'] = Variable<DateTime>(earnedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AchievementsCompanion(')
          ..write('learnerId: $learnerId, ')
          ..write('achievementId: $achievementId, ')
          ..write('earnedAt: $earnedAt, ')
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
  static const VerificationMeta _learnerIdMeta = const VerificationMeta(
    'learnerId',
  );
  @override
  late final GeneratedColumn<String> learnerId = GeneratedColumn<String>(
    'learner_id',
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
  List<GeneratedColumn> get $columns => [learnerId, accessoryId, purchasedAt];
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
    if (data.containsKey('learner_id')) {
      context.handle(
        _learnerIdMeta,
        learnerId.isAcceptableOrUnknown(data['learner_id']!, _learnerIdMeta),
      );
    } else if (isInserting) {
      context.missing(_learnerIdMeta);
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
  Set<GeneratedColumn> get $primaryKey => {learnerId, accessoryId};
  @override
  OwnedAccessory map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return OwnedAccessory(
      learnerId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}learner_id'],
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
  final String learnerId;
  final String accessoryId;
  final DateTime purchasedAt;
  const OwnedAccessory({
    required this.learnerId,
    required this.accessoryId,
    required this.purchasedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['learner_id'] = Variable<String>(learnerId);
    map['accessory_id'] = Variable<String>(accessoryId);
    map['purchased_at'] = Variable<DateTime>(purchasedAt);
    return map;
  }

  OwnedAccessoriesCompanion toCompanion(bool nullToAbsent) {
    return OwnedAccessoriesCompanion(
      learnerId: Value(learnerId),
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
      learnerId: serializer.fromJson<String>(json['learnerId']),
      accessoryId: serializer.fromJson<String>(json['accessoryId']),
      purchasedAt: serializer.fromJson<DateTime>(json['purchasedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'learnerId': serializer.toJson<String>(learnerId),
      'accessoryId': serializer.toJson<String>(accessoryId),
      'purchasedAt': serializer.toJson<DateTime>(purchasedAt),
    };
  }

  OwnedAccessory copyWith({
    String? learnerId,
    String? accessoryId,
    DateTime? purchasedAt,
  }) => OwnedAccessory(
    learnerId: learnerId ?? this.learnerId,
    accessoryId: accessoryId ?? this.accessoryId,
    purchasedAt: purchasedAt ?? this.purchasedAt,
  );
  OwnedAccessory copyWithCompanion(OwnedAccessoriesCompanion data) {
    return OwnedAccessory(
      learnerId: data.learnerId.present ? data.learnerId.value : this.learnerId,
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
          ..write('learnerId: $learnerId, ')
          ..write('accessoryId: $accessoryId, ')
          ..write('purchasedAt: $purchasedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(learnerId, accessoryId, purchasedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is OwnedAccessory &&
          other.learnerId == this.learnerId &&
          other.accessoryId == this.accessoryId &&
          other.purchasedAt == this.purchasedAt);
}

class OwnedAccessoriesCompanion extends UpdateCompanion<OwnedAccessory> {
  final Value<String> learnerId;
  final Value<String> accessoryId;
  final Value<DateTime> purchasedAt;
  final Value<int> rowid;
  const OwnedAccessoriesCompanion({
    this.learnerId = const Value.absent(),
    this.accessoryId = const Value.absent(),
    this.purchasedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  OwnedAccessoriesCompanion.insert({
    required String learnerId,
    required String accessoryId,
    required DateTime purchasedAt,
    this.rowid = const Value.absent(),
  }) : learnerId = Value(learnerId),
       accessoryId = Value(accessoryId),
       purchasedAt = Value(purchasedAt);
  static Insertable<OwnedAccessory> custom({
    Expression<String>? learnerId,
    Expression<String>? accessoryId,
    Expression<DateTime>? purchasedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (learnerId != null) 'learner_id': learnerId,
      if (accessoryId != null) 'accessory_id': accessoryId,
      if (purchasedAt != null) 'purchased_at': purchasedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  OwnedAccessoriesCompanion copyWith({
    Value<String>? learnerId,
    Value<String>? accessoryId,
    Value<DateTime>? purchasedAt,
    Value<int>? rowid,
  }) {
    return OwnedAccessoriesCompanion(
      learnerId: learnerId ?? this.learnerId,
      accessoryId: accessoryId ?? this.accessoryId,
      purchasedAt: purchasedAt ?? this.purchasedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (learnerId.present) {
      map['learner_id'] = Variable<String>(learnerId.value);
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
          ..write('learnerId: $learnerId, ')
          ..write('accessoryId: $accessoryId, ')
          ..write('purchasedAt: $purchasedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $EquippedAccessoriesTable extends EquippedAccessories
    with TableInfo<$EquippedAccessoriesTable, EquippedAccessory> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $EquippedAccessoriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _learnerIdMeta = const VerificationMeta(
    'learnerId',
  );
  @override
  late final GeneratedColumn<String> learnerId = GeneratedColumn<String>(
    'learner_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _slotMeta = const VerificationMeta('slot');
  @override
  late final GeneratedColumn<String> slot = GeneratedColumn<String>(
    'slot',
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
  static const VerificationMeta _equippedAtMeta = const VerificationMeta(
    'equippedAt',
  );
  @override
  late final GeneratedColumn<DateTime> equippedAt = GeneratedColumn<DateTime>(
    'equipped_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    learnerId,
    slot,
    accessoryId,
    equippedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'equipped_accessories';
  @override
  VerificationContext validateIntegrity(
    Insertable<EquippedAccessory> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('learner_id')) {
      context.handle(
        _learnerIdMeta,
        learnerId.isAcceptableOrUnknown(data['learner_id']!, _learnerIdMeta),
      );
    } else if (isInserting) {
      context.missing(_learnerIdMeta);
    }
    if (data.containsKey('slot')) {
      context.handle(
        _slotMeta,
        slot.isAcceptableOrUnknown(data['slot']!, _slotMeta),
      );
    } else if (isInserting) {
      context.missing(_slotMeta);
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
    if (data.containsKey('equipped_at')) {
      context.handle(
        _equippedAtMeta,
        equippedAt.isAcceptableOrUnknown(data['equipped_at']!, _equippedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_equippedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {learnerId, slot};
  @override
  EquippedAccessory map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return EquippedAccessory(
      learnerId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}learner_id'],
      )!,
      slot: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}slot'],
      )!,
      accessoryId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}accessory_id'],
      )!,
      equippedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}equipped_at'],
      )!,
    );
  }

  @override
  $EquippedAccessoriesTable createAlias(String alias) {
    return $EquippedAccessoriesTable(attachedDatabase, alias);
  }
}

class EquippedAccessory extends DataClass
    implements Insertable<EquippedAccessory> {
  final String learnerId;
  final String slot;
  final String accessoryId;
  final DateTime equippedAt;
  const EquippedAccessory({
    required this.learnerId,
    required this.slot,
    required this.accessoryId,
    required this.equippedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['learner_id'] = Variable<String>(learnerId);
    map['slot'] = Variable<String>(slot);
    map['accessory_id'] = Variable<String>(accessoryId);
    map['equipped_at'] = Variable<DateTime>(equippedAt);
    return map;
  }

  EquippedAccessoriesCompanion toCompanion(bool nullToAbsent) {
    return EquippedAccessoriesCompanion(
      learnerId: Value(learnerId),
      slot: Value(slot),
      accessoryId: Value(accessoryId),
      equippedAt: Value(equippedAt),
    );
  }

  factory EquippedAccessory.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return EquippedAccessory(
      learnerId: serializer.fromJson<String>(json['learnerId']),
      slot: serializer.fromJson<String>(json['slot']),
      accessoryId: serializer.fromJson<String>(json['accessoryId']),
      equippedAt: serializer.fromJson<DateTime>(json['equippedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'learnerId': serializer.toJson<String>(learnerId),
      'slot': serializer.toJson<String>(slot),
      'accessoryId': serializer.toJson<String>(accessoryId),
      'equippedAt': serializer.toJson<DateTime>(equippedAt),
    };
  }

  EquippedAccessory copyWith({
    String? learnerId,
    String? slot,
    String? accessoryId,
    DateTime? equippedAt,
  }) => EquippedAccessory(
    learnerId: learnerId ?? this.learnerId,
    slot: slot ?? this.slot,
    accessoryId: accessoryId ?? this.accessoryId,
    equippedAt: equippedAt ?? this.equippedAt,
  );
  EquippedAccessory copyWithCompanion(EquippedAccessoriesCompanion data) {
    return EquippedAccessory(
      learnerId: data.learnerId.present ? data.learnerId.value : this.learnerId,
      slot: data.slot.present ? data.slot.value : this.slot,
      accessoryId: data.accessoryId.present
          ? data.accessoryId.value
          : this.accessoryId,
      equippedAt: data.equippedAt.present
          ? data.equippedAt.value
          : this.equippedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('EquippedAccessory(')
          ..write('learnerId: $learnerId, ')
          ..write('slot: $slot, ')
          ..write('accessoryId: $accessoryId, ')
          ..write('equippedAt: $equippedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(learnerId, slot, accessoryId, equippedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is EquippedAccessory &&
          other.learnerId == this.learnerId &&
          other.slot == this.slot &&
          other.accessoryId == this.accessoryId &&
          other.equippedAt == this.equippedAt);
}

class EquippedAccessoriesCompanion extends UpdateCompanion<EquippedAccessory> {
  final Value<String> learnerId;
  final Value<String> slot;
  final Value<String> accessoryId;
  final Value<DateTime> equippedAt;
  final Value<int> rowid;
  const EquippedAccessoriesCompanion({
    this.learnerId = const Value.absent(),
    this.slot = const Value.absent(),
    this.accessoryId = const Value.absent(),
    this.equippedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  EquippedAccessoriesCompanion.insert({
    required String learnerId,
    required String slot,
    required String accessoryId,
    required DateTime equippedAt,
    this.rowid = const Value.absent(),
  }) : learnerId = Value(learnerId),
       slot = Value(slot),
       accessoryId = Value(accessoryId),
       equippedAt = Value(equippedAt);
  static Insertable<EquippedAccessory> custom({
    Expression<String>? learnerId,
    Expression<String>? slot,
    Expression<String>? accessoryId,
    Expression<DateTime>? equippedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (learnerId != null) 'learner_id': learnerId,
      if (slot != null) 'slot': slot,
      if (accessoryId != null) 'accessory_id': accessoryId,
      if (equippedAt != null) 'equipped_at': equippedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  EquippedAccessoriesCompanion copyWith({
    Value<String>? learnerId,
    Value<String>? slot,
    Value<String>? accessoryId,
    Value<DateTime>? equippedAt,
    Value<int>? rowid,
  }) {
    return EquippedAccessoriesCompanion(
      learnerId: learnerId ?? this.learnerId,
      slot: slot ?? this.slot,
      accessoryId: accessoryId ?? this.accessoryId,
      equippedAt: equippedAt ?? this.equippedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (learnerId.present) {
      map['learner_id'] = Variable<String>(learnerId.value);
    }
    if (slot.present) {
      map['slot'] = Variable<String>(slot.value);
    }
    if (accessoryId.present) {
      map['accessory_id'] = Variable<String>(accessoryId.value);
    }
    if (equippedAt.present) {
      map['equipped_at'] = Variable<DateTime>(equippedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('EquippedAccessoriesCompanion(')
          ..write('learnerId: $learnerId, ')
          ..write('slot: $slot, ')
          ..write('accessoryId: $accessoryId, ')
          ..write('equippedAt: $equippedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SyncOutboxTable extends SyncOutbox
    with TableInfo<$SyncOutboxTable, SyncOutboxData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SyncOutboxTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _eventIdMeta = const VerificationMeta(
    'eventId',
  );
  @override
  late final GeneratedColumn<String> eventId = GeneratedColumn<String>(
    'event_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
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
  static const VerificationMeta _nextAttemptAtMeta = const VerificationMeta(
    'nextAttemptAt',
  );
  @override
  late final GeneratedColumn<DateTime> nextAttemptAt =
      GeneratedColumn<DateTime>(
        'next_attempt_at',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _lastErrorMeta = const VerificationMeta(
    'lastError',
  );
  @override
  late final GeneratedColumn<String> lastError = GeneratedColumn<String>(
    'last_error',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _syncedAtMeta = const VerificationMeta(
    'syncedAt',
  );
  @override
  late final GeneratedColumn<DateTime> syncedAt = GeneratedColumn<DateTime>(
    'synced_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    eventId,
    operation,
    payloadJson,
    createdAt,
    attempts,
    nextAttemptAt,
    lastError,
    syncedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'sync_outbox';
  @override
  VerificationContext validateIntegrity(
    Insertable<SyncOutboxData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('event_id')) {
      context.handle(
        _eventIdMeta,
        eventId.isAcceptableOrUnknown(data['event_id']!, _eventIdMeta),
      );
    } else if (isInserting) {
      context.missing(_eventIdMeta);
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
    if (data.containsKey('next_attempt_at')) {
      context.handle(
        _nextAttemptAtMeta,
        nextAttemptAt.isAcceptableOrUnknown(
          data['next_attempt_at']!,
          _nextAttemptAtMeta,
        ),
      );
    }
    if (data.containsKey('last_error')) {
      context.handle(
        _lastErrorMeta,
        lastError.isAcceptableOrUnknown(data['last_error']!, _lastErrorMeta),
      );
    }
    if (data.containsKey('synced_at')) {
      context.handle(
        _syncedAtMeta,
        syncedAt.isAcceptableOrUnknown(data['synced_at']!, _syncedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SyncOutboxData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SyncOutboxData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      eventId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}event_id'],
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
      nextAttemptAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}next_attempt_at'],
      ),
      lastError: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}last_error'],
      ),
      syncedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}synced_at'],
      ),
    );
  }

  @override
  $SyncOutboxTable createAlias(String alias) {
    return $SyncOutboxTable(attachedDatabase, alias);
  }
}

class SyncOutboxData extends DataClass implements Insertable<SyncOutboxData> {
  final String id;
  final String eventId;
  final String operation;
  final String payloadJson;
  final DateTime createdAt;
  final int attempts;
  final DateTime? nextAttemptAt;
  final String? lastError;
  final DateTime? syncedAt;
  const SyncOutboxData({
    required this.id,
    required this.eventId,
    required this.operation,
    required this.payloadJson,
    required this.createdAt,
    required this.attempts,
    this.nextAttemptAt,
    this.lastError,
    this.syncedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['event_id'] = Variable<String>(eventId);
    map['operation'] = Variable<String>(operation);
    map['payload_json'] = Variable<String>(payloadJson);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['attempts'] = Variable<int>(attempts);
    if (!nullToAbsent || nextAttemptAt != null) {
      map['next_attempt_at'] = Variable<DateTime>(nextAttemptAt);
    }
    if (!nullToAbsent || lastError != null) {
      map['last_error'] = Variable<String>(lastError);
    }
    if (!nullToAbsent || syncedAt != null) {
      map['synced_at'] = Variable<DateTime>(syncedAt);
    }
    return map;
  }

  SyncOutboxCompanion toCompanion(bool nullToAbsent) {
    return SyncOutboxCompanion(
      id: Value(id),
      eventId: Value(eventId),
      operation: Value(operation),
      payloadJson: Value(payloadJson),
      createdAt: Value(createdAt),
      attempts: Value(attempts),
      nextAttemptAt: nextAttemptAt == null && nullToAbsent
          ? const Value.absent()
          : Value(nextAttemptAt),
      lastError: lastError == null && nullToAbsent
          ? const Value.absent()
          : Value(lastError),
      syncedAt: syncedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(syncedAt),
    );
  }

  factory SyncOutboxData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SyncOutboxData(
      id: serializer.fromJson<String>(json['id']),
      eventId: serializer.fromJson<String>(json['eventId']),
      operation: serializer.fromJson<String>(json['operation']),
      payloadJson: serializer.fromJson<String>(json['payloadJson']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      attempts: serializer.fromJson<int>(json['attempts']),
      nextAttemptAt: serializer.fromJson<DateTime?>(json['nextAttemptAt']),
      lastError: serializer.fromJson<String?>(json['lastError']),
      syncedAt: serializer.fromJson<DateTime?>(json['syncedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'eventId': serializer.toJson<String>(eventId),
      'operation': serializer.toJson<String>(operation),
      'payloadJson': serializer.toJson<String>(payloadJson),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'attempts': serializer.toJson<int>(attempts),
      'nextAttemptAt': serializer.toJson<DateTime?>(nextAttemptAt),
      'lastError': serializer.toJson<String?>(lastError),
      'syncedAt': serializer.toJson<DateTime?>(syncedAt),
    };
  }

  SyncOutboxData copyWith({
    String? id,
    String? eventId,
    String? operation,
    String? payloadJson,
    DateTime? createdAt,
    int? attempts,
    Value<DateTime?> nextAttemptAt = const Value.absent(),
    Value<String?> lastError = const Value.absent(),
    Value<DateTime?> syncedAt = const Value.absent(),
  }) => SyncOutboxData(
    id: id ?? this.id,
    eventId: eventId ?? this.eventId,
    operation: operation ?? this.operation,
    payloadJson: payloadJson ?? this.payloadJson,
    createdAt: createdAt ?? this.createdAt,
    attempts: attempts ?? this.attempts,
    nextAttemptAt: nextAttemptAt.present
        ? nextAttemptAt.value
        : this.nextAttemptAt,
    lastError: lastError.present ? lastError.value : this.lastError,
    syncedAt: syncedAt.present ? syncedAt.value : this.syncedAt,
  );
  SyncOutboxData copyWithCompanion(SyncOutboxCompanion data) {
    return SyncOutboxData(
      id: data.id.present ? data.id.value : this.id,
      eventId: data.eventId.present ? data.eventId.value : this.eventId,
      operation: data.operation.present ? data.operation.value : this.operation,
      payloadJson: data.payloadJson.present
          ? data.payloadJson.value
          : this.payloadJson,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      attempts: data.attempts.present ? data.attempts.value : this.attempts,
      nextAttemptAt: data.nextAttemptAt.present
          ? data.nextAttemptAt.value
          : this.nextAttemptAt,
      lastError: data.lastError.present ? data.lastError.value : this.lastError,
      syncedAt: data.syncedAt.present ? data.syncedAt.value : this.syncedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SyncOutboxData(')
          ..write('id: $id, ')
          ..write('eventId: $eventId, ')
          ..write('operation: $operation, ')
          ..write('payloadJson: $payloadJson, ')
          ..write('createdAt: $createdAt, ')
          ..write('attempts: $attempts, ')
          ..write('nextAttemptAt: $nextAttemptAt, ')
          ..write('lastError: $lastError, ')
          ..write('syncedAt: $syncedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    eventId,
    operation,
    payloadJson,
    createdAt,
    attempts,
    nextAttemptAt,
    lastError,
    syncedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SyncOutboxData &&
          other.id == this.id &&
          other.eventId == this.eventId &&
          other.operation == this.operation &&
          other.payloadJson == this.payloadJson &&
          other.createdAt == this.createdAt &&
          other.attempts == this.attempts &&
          other.nextAttemptAt == this.nextAttemptAt &&
          other.lastError == this.lastError &&
          other.syncedAt == this.syncedAt);
}

class SyncOutboxCompanion extends UpdateCompanion<SyncOutboxData> {
  final Value<String> id;
  final Value<String> eventId;
  final Value<String> operation;
  final Value<String> payloadJson;
  final Value<DateTime> createdAt;
  final Value<int> attempts;
  final Value<DateTime?> nextAttemptAt;
  final Value<String?> lastError;
  final Value<DateTime?> syncedAt;
  final Value<int> rowid;
  const SyncOutboxCompanion({
    this.id = const Value.absent(),
    this.eventId = const Value.absent(),
    this.operation = const Value.absent(),
    this.payloadJson = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.attempts = const Value.absent(),
    this.nextAttemptAt = const Value.absent(),
    this.lastError = const Value.absent(),
    this.syncedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SyncOutboxCompanion.insert({
    required String id,
    required String eventId,
    required String operation,
    required String payloadJson,
    required DateTime createdAt,
    this.attempts = const Value.absent(),
    this.nextAttemptAt = const Value.absent(),
    this.lastError = const Value.absent(),
    this.syncedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       eventId = Value(eventId),
       operation = Value(operation),
       payloadJson = Value(payloadJson),
       createdAt = Value(createdAt);
  static Insertable<SyncOutboxData> custom({
    Expression<String>? id,
    Expression<String>? eventId,
    Expression<String>? operation,
    Expression<String>? payloadJson,
    Expression<DateTime>? createdAt,
    Expression<int>? attempts,
    Expression<DateTime>? nextAttemptAt,
    Expression<String>? lastError,
    Expression<DateTime>? syncedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (eventId != null) 'event_id': eventId,
      if (operation != null) 'operation': operation,
      if (payloadJson != null) 'payload_json': payloadJson,
      if (createdAt != null) 'created_at': createdAt,
      if (attempts != null) 'attempts': attempts,
      if (nextAttemptAt != null) 'next_attempt_at': nextAttemptAt,
      if (lastError != null) 'last_error': lastError,
      if (syncedAt != null) 'synced_at': syncedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SyncOutboxCompanion copyWith({
    Value<String>? id,
    Value<String>? eventId,
    Value<String>? operation,
    Value<String>? payloadJson,
    Value<DateTime>? createdAt,
    Value<int>? attempts,
    Value<DateTime?>? nextAttemptAt,
    Value<String?>? lastError,
    Value<DateTime?>? syncedAt,
    Value<int>? rowid,
  }) {
    return SyncOutboxCompanion(
      id: id ?? this.id,
      eventId: eventId ?? this.eventId,
      operation: operation ?? this.operation,
      payloadJson: payloadJson ?? this.payloadJson,
      createdAt: createdAt ?? this.createdAt,
      attempts: attempts ?? this.attempts,
      nextAttemptAt: nextAttemptAt ?? this.nextAttemptAt,
      lastError: lastError ?? this.lastError,
      syncedAt: syncedAt ?? this.syncedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (eventId.present) {
      map['event_id'] = Variable<String>(eventId.value);
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
    if (nextAttemptAt.present) {
      map['next_attempt_at'] = Variable<DateTime>(nextAttemptAt.value);
    }
    if (lastError.present) {
      map['last_error'] = Variable<String>(lastError.value);
    }
    if (syncedAt.present) {
      map['synced_at'] = Variable<DateTime>(syncedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SyncOutboxCompanion(')
          ..write('id: $id, ')
          ..write('eventId: $eventId, ')
          ..write('operation: $operation, ')
          ..write('payloadJson: $payloadJson, ')
          ..write('createdAt: $createdAt, ')
          ..write('attempts: $attempts, ')
          ..write('nextAttemptAt: $nextAttemptAt, ')
          ..write('lastError: $lastError, ')
          ..write('syncedAt: $syncedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SyncMetadataTable extends SyncMetadata
    with TableInfo<$SyncMetadataTable, SyncMetadataData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SyncMetadataTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _keyMeta = const VerificationMeta('key');
  @override
  late final GeneratedColumn<String> key = GeneratedColumn<String>(
    'key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _valueMeta = const VerificationMeta('value');
  @override
  late final GeneratedColumn<String> value = GeneratedColumn<String>(
    'value',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [key, value, updatedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'sync_metadata';
  @override
  VerificationContext validateIntegrity(
    Insertable<SyncMetadataData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('key')) {
      context.handle(
        _keyMeta,
        key.isAcceptableOrUnknown(data['key']!, _keyMeta),
      );
    } else if (isInserting) {
      context.missing(_keyMeta);
    }
    if (data.containsKey('value')) {
      context.handle(
        _valueMeta,
        value.isAcceptableOrUnknown(data['value']!, _valueMeta),
      );
    } else if (isInserting) {
      context.missing(_valueMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {key};
  @override
  SyncMetadataData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SyncMetadataData(
      key: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}key'],
      )!,
      value: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}value'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $SyncMetadataTable createAlias(String alias) {
    return $SyncMetadataTable(attachedDatabase, alias);
  }
}

class SyncMetadataData extends DataClass
    implements Insertable<SyncMetadataData> {
  final String key;
  final String value;
  final DateTime updatedAt;
  const SyncMetadataData({
    required this.key,
    required this.value,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['key'] = Variable<String>(key);
    map['value'] = Variable<String>(value);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  SyncMetadataCompanion toCompanion(bool nullToAbsent) {
    return SyncMetadataCompanion(
      key: Value(key),
      value: Value(value),
      updatedAt: Value(updatedAt),
    );
  }

  factory SyncMetadataData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SyncMetadataData(
      key: serializer.fromJson<String>(json['key']),
      value: serializer.fromJson<String>(json['value']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'key': serializer.toJson<String>(key),
      'value': serializer.toJson<String>(value),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  SyncMetadataData copyWith({
    String? key,
    String? value,
    DateTime? updatedAt,
  }) => SyncMetadataData(
    key: key ?? this.key,
    value: value ?? this.value,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  SyncMetadataData copyWithCompanion(SyncMetadataCompanion data) {
    return SyncMetadataData(
      key: data.key.present ? data.key.value : this.key,
      value: data.value.present ? data.value.value : this.value,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SyncMetadataData(')
          ..write('key: $key, ')
          ..write('value: $value, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(key, value, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SyncMetadataData &&
          other.key == this.key &&
          other.value == this.value &&
          other.updatedAt == this.updatedAt);
}

class SyncMetadataCompanion extends UpdateCompanion<SyncMetadataData> {
  final Value<String> key;
  final Value<String> value;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const SyncMetadataCompanion({
    this.key = const Value.absent(),
    this.value = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SyncMetadataCompanion.insert({
    required String key,
    required String value,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  }) : key = Value(key),
       value = Value(value),
       updatedAt = Value(updatedAt);
  static Insertable<SyncMetadataData> custom({
    Expression<String>? key,
    Expression<String>? value,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (key != null) 'key': key,
      if (value != null) 'value': value,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SyncMetadataCompanion copyWith({
    Value<String>? key,
    Value<String>? value,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return SyncMetadataCompanion(
      key: key ?? this.key,
      value: value ?? this.value,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (key.present) {
      map['key'] = Variable<String>(key.value);
    }
    if (value.present) {
      map['value'] = Variable<String>(value.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SyncMetadataCompanion(')
          ..write('key: $key, ')
          ..write('value: $value, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $DeletionRequestsTable extends DeletionRequests
    with TableInfo<$DeletionRequestsTable, DeletionRequest> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DeletionRequestsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _targetMeta = const VerificationMeta('target');
  @override
  late final GeneratedColumn<String> target = GeneratedColumn<String>(
    'target',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _requestedAtMeta = const VerificationMeta(
    'requestedAt',
  );
  @override
  late final GeneratedColumn<DateTime> requestedAt = GeneratedColumn<DateTime>(
    'requested_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _scheduledForMeta = const VerificationMeta(
    'scheduledFor',
  );
  @override
  late final GeneratedColumn<DateTime> scheduledFor = GeneratedColumn<DateTime>(
    'scheduled_for',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _cancelledAtMeta = const VerificationMeta(
    'cancelledAt',
  );
  @override
  late final GeneratedColumn<DateTime> cancelledAt = GeneratedColumn<DateTime>(
    'cancelled_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    target,
    status,
    requestedAt,
    scheduledFor,
    cancelledAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'deletion_requests';
  @override
  VerificationContext validateIntegrity(
    Insertable<DeletionRequest> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('target')) {
      context.handle(
        _targetMeta,
        target.isAcceptableOrUnknown(data['target']!, _targetMeta),
      );
    } else if (isInserting) {
      context.missing(_targetMeta);
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    } else if (isInserting) {
      context.missing(_statusMeta);
    }
    if (data.containsKey('requested_at')) {
      context.handle(
        _requestedAtMeta,
        requestedAt.isAcceptableOrUnknown(
          data['requested_at']!,
          _requestedAtMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_requestedAtMeta);
    }
    if (data.containsKey('scheduled_for')) {
      context.handle(
        _scheduledForMeta,
        scheduledFor.isAcceptableOrUnknown(
          data['scheduled_for']!,
          _scheduledForMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_scheduledForMeta);
    }
    if (data.containsKey('cancelled_at')) {
      context.handle(
        _cancelledAtMeta,
        cancelledAt.isAcceptableOrUnknown(
          data['cancelled_at']!,
          _cancelledAtMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  DeletionRequest map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DeletionRequest(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      target: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}target'],
      )!,
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      requestedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}requested_at'],
      )!,
      scheduledFor: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}scheduled_for'],
      )!,
      cancelledAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}cancelled_at'],
      ),
    );
  }

  @override
  $DeletionRequestsTable createAlias(String alias) {
    return $DeletionRequestsTable(attachedDatabase, alias);
  }
}

class DeletionRequest extends DataClass implements Insertable<DeletionRequest> {
  final String id;
  final String target;
  final String status;
  final DateTime requestedAt;
  final DateTime scheduledFor;
  final DateTime? cancelledAt;
  const DeletionRequest({
    required this.id,
    required this.target,
    required this.status,
    required this.requestedAt,
    required this.scheduledFor,
    this.cancelledAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['target'] = Variable<String>(target);
    map['status'] = Variable<String>(status);
    map['requested_at'] = Variable<DateTime>(requestedAt);
    map['scheduled_for'] = Variable<DateTime>(scheduledFor);
    if (!nullToAbsent || cancelledAt != null) {
      map['cancelled_at'] = Variable<DateTime>(cancelledAt);
    }
    return map;
  }

  DeletionRequestsCompanion toCompanion(bool nullToAbsent) {
    return DeletionRequestsCompanion(
      id: Value(id),
      target: Value(target),
      status: Value(status),
      requestedAt: Value(requestedAt),
      scheduledFor: Value(scheduledFor),
      cancelledAt: cancelledAt == null && nullToAbsent
          ? const Value.absent()
          : Value(cancelledAt),
    );
  }

  factory DeletionRequest.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DeletionRequest(
      id: serializer.fromJson<String>(json['id']),
      target: serializer.fromJson<String>(json['target']),
      status: serializer.fromJson<String>(json['status']),
      requestedAt: serializer.fromJson<DateTime>(json['requestedAt']),
      scheduledFor: serializer.fromJson<DateTime>(json['scheduledFor']),
      cancelledAt: serializer.fromJson<DateTime?>(json['cancelledAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'target': serializer.toJson<String>(target),
      'status': serializer.toJson<String>(status),
      'requestedAt': serializer.toJson<DateTime>(requestedAt),
      'scheduledFor': serializer.toJson<DateTime>(scheduledFor),
      'cancelledAt': serializer.toJson<DateTime?>(cancelledAt),
    };
  }

  DeletionRequest copyWith({
    String? id,
    String? target,
    String? status,
    DateTime? requestedAt,
    DateTime? scheduledFor,
    Value<DateTime?> cancelledAt = const Value.absent(),
  }) => DeletionRequest(
    id: id ?? this.id,
    target: target ?? this.target,
    status: status ?? this.status,
    requestedAt: requestedAt ?? this.requestedAt,
    scheduledFor: scheduledFor ?? this.scheduledFor,
    cancelledAt: cancelledAt.present ? cancelledAt.value : this.cancelledAt,
  );
  DeletionRequest copyWithCompanion(DeletionRequestsCompanion data) {
    return DeletionRequest(
      id: data.id.present ? data.id.value : this.id,
      target: data.target.present ? data.target.value : this.target,
      status: data.status.present ? data.status.value : this.status,
      requestedAt: data.requestedAt.present
          ? data.requestedAt.value
          : this.requestedAt,
      scheduledFor: data.scheduledFor.present
          ? data.scheduledFor.value
          : this.scheduledFor,
      cancelledAt: data.cancelledAt.present
          ? data.cancelledAt.value
          : this.cancelledAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DeletionRequest(')
          ..write('id: $id, ')
          ..write('target: $target, ')
          ..write('status: $status, ')
          ..write('requestedAt: $requestedAt, ')
          ..write('scheduledFor: $scheduledFor, ')
          ..write('cancelledAt: $cancelledAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, target, status, requestedAt, scheduledFor, cancelledAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DeletionRequest &&
          other.id == this.id &&
          other.target == this.target &&
          other.status == this.status &&
          other.requestedAt == this.requestedAt &&
          other.scheduledFor == this.scheduledFor &&
          other.cancelledAt == this.cancelledAt);
}

class DeletionRequestsCompanion extends UpdateCompanion<DeletionRequest> {
  final Value<String> id;
  final Value<String> target;
  final Value<String> status;
  final Value<DateTime> requestedAt;
  final Value<DateTime> scheduledFor;
  final Value<DateTime?> cancelledAt;
  final Value<int> rowid;
  const DeletionRequestsCompanion({
    this.id = const Value.absent(),
    this.target = const Value.absent(),
    this.status = const Value.absent(),
    this.requestedAt = const Value.absent(),
    this.scheduledFor = const Value.absent(),
    this.cancelledAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  DeletionRequestsCompanion.insert({
    required String id,
    required String target,
    required String status,
    required DateTime requestedAt,
    required DateTime scheduledFor,
    this.cancelledAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       target = Value(target),
       status = Value(status),
       requestedAt = Value(requestedAt),
       scheduledFor = Value(scheduledFor);
  static Insertable<DeletionRequest> custom({
    Expression<String>? id,
    Expression<String>? target,
    Expression<String>? status,
    Expression<DateTime>? requestedAt,
    Expression<DateTime>? scheduledFor,
    Expression<DateTime>? cancelledAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (target != null) 'target': target,
      if (status != null) 'status': status,
      if (requestedAt != null) 'requested_at': requestedAt,
      if (scheduledFor != null) 'scheduled_for': scheduledFor,
      if (cancelledAt != null) 'cancelled_at': cancelledAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  DeletionRequestsCompanion copyWith({
    Value<String>? id,
    Value<String>? target,
    Value<String>? status,
    Value<DateTime>? requestedAt,
    Value<DateTime>? scheduledFor,
    Value<DateTime?>? cancelledAt,
    Value<int>? rowid,
  }) {
    return DeletionRequestsCompanion(
      id: id ?? this.id,
      target: target ?? this.target,
      status: status ?? this.status,
      requestedAt: requestedAt ?? this.requestedAt,
      scheduledFor: scheduledFor ?? this.scheduledFor,
      cancelledAt: cancelledAt ?? this.cancelledAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (target.present) {
      map['target'] = Variable<String>(target.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (requestedAt.present) {
      map['requested_at'] = Variable<DateTime>(requestedAt.value);
    }
    if (scheduledFor.present) {
      map['scheduled_for'] = Variable<DateTime>(scheduledFor.value);
    }
    if (cancelledAt.present) {
      map['cancelled_at'] = Variable<DateTime>(cancelledAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DeletionRequestsCompanion(')
          ..write('id: $id, ')
          ..write('target: $target, ')
          ..write('status: $status, ')
          ..write('requestedAt: $requestedAt, ')
          ..write('scheduledFor: $scheduledFor, ')
          ..write('cancelledAt: $cancelledAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $AppMetadataTable extends AppMetadata
    with TableInfo<$AppMetadataTable, AppMetadataData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AppMetadataTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _keyMeta = const VerificationMeta('key');
  @override
  late final GeneratedColumn<String> key = GeneratedColumn<String>(
    'key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _valueMeta = const VerificationMeta('value');
  @override
  late final GeneratedColumn<String> value = GeneratedColumn<String>(
    'value',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [key, value, updatedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'app_metadata';
  @override
  VerificationContext validateIntegrity(
    Insertable<AppMetadataData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('key')) {
      context.handle(
        _keyMeta,
        key.isAcceptableOrUnknown(data['key']!, _keyMeta),
      );
    } else if (isInserting) {
      context.missing(_keyMeta);
    }
    if (data.containsKey('value')) {
      context.handle(
        _valueMeta,
        value.isAcceptableOrUnknown(data['value']!, _valueMeta),
      );
    } else if (isInserting) {
      context.missing(_valueMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {key};
  @override
  AppMetadataData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AppMetadataData(
      key: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}key'],
      )!,
      value: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}value'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $AppMetadataTable createAlias(String alias) {
    return $AppMetadataTable(attachedDatabase, alias);
  }
}

class AppMetadataData extends DataClass implements Insertable<AppMetadataData> {
  final String key;
  final String value;
  final DateTime updatedAt;
  const AppMetadataData({
    required this.key,
    required this.value,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['key'] = Variable<String>(key);
    map['value'] = Variable<String>(value);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  AppMetadataCompanion toCompanion(bool nullToAbsent) {
    return AppMetadataCompanion(
      key: Value(key),
      value: Value(value),
      updatedAt: Value(updatedAt),
    );
  }

  factory AppMetadataData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AppMetadataData(
      key: serializer.fromJson<String>(json['key']),
      value: serializer.fromJson<String>(json['value']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'key': serializer.toJson<String>(key),
      'value': serializer.toJson<String>(value),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  AppMetadataData copyWith({String? key, String? value, DateTime? updatedAt}) =>
      AppMetadataData(
        key: key ?? this.key,
        value: value ?? this.value,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  AppMetadataData copyWithCompanion(AppMetadataCompanion data) {
    return AppMetadataData(
      key: data.key.present ? data.key.value : this.key,
      value: data.value.present ? data.value.value : this.value,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AppMetadataData(')
          ..write('key: $key, ')
          ..write('value: $value, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(key, value, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AppMetadataData &&
          other.key == this.key &&
          other.value == this.value &&
          other.updatedAt == this.updatedAt);
}

class AppMetadataCompanion extends UpdateCompanion<AppMetadataData> {
  final Value<String> key;
  final Value<String> value;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const AppMetadataCompanion({
    this.key = const Value.absent(),
    this.value = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  AppMetadataCompanion.insert({
    required String key,
    required String value,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  }) : key = Value(key),
       value = Value(value),
       updatedAt = Value(updatedAt);
  static Insertable<AppMetadataData> custom({
    Expression<String>? key,
    Expression<String>? value,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (key != null) 'key': key,
      if (value != null) 'value': value,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  AppMetadataCompanion copyWith({
    Value<String>? key,
    Value<String>? value,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return AppMetadataCompanion(
      key: key ?? this.key,
      value: value ?? this.value,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (key.present) {
      map['key'] = Variable<String>(key.value);
    }
    if (value.present) {
      map['value'] = Variable<String>(value.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AppMetadataCompanion(')
          ..write('key: $key, ')
          ..write('value: $value, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $ParentProfilesTable parentProfiles = $ParentProfilesTable(this);
  late final $ConsentRecordsTable consentRecords = $ConsentRecordsTable(this);
  late final $LearnerProfilesTable learnerProfiles = $LearnerProfilesTable(
    this,
  );
  late final $ActivityProgressTable activityProgress = $ActivityProgressTable(
    this,
  );
  late final $RewardTransactionsTable rewardTransactions =
      $RewardTransactionsTable(this);
  late final $AchievementsTable achievements = $AchievementsTable(this);
  late final $OwnedAccessoriesTable ownedAccessories = $OwnedAccessoriesTable(
    this,
  );
  late final $EquippedAccessoriesTable equippedAccessories =
      $EquippedAccessoriesTable(this);
  late final $SyncOutboxTable syncOutbox = $SyncOutboxTable(this);
  late final $SyncMetadataTable syncMetadata = $SyncMetadataTable(this);
  late final $DeletionRequestsTable deletionRequests = $DeletionRequestsTable(
    this,
  );
  late final $AppMetadataTable appMetadata = $AppMetadataTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    parentProfiles,
    consentRecords,
    learnerProfiles,
    activityProgress,
    rewardTransactions,
    achievements,
    ownedAccessories,
    equippedAccessories,
    syncOutbox,
    syncMetadata,
    deletionRequests,
    appMetadata,
  ];
}

typedef $$ParentProfilesTableCreateCompanionBuilder =
    ParentProfilesCompanion Function({
      required String id,
      Value<String?> authUserId,
      required String displayName,
      required DateTime createdAt,
      required DateTime updatedAt,
      Value<int> rowid,
    });
typedef $$ParentProfilesTableUpdateCompanionBuilder =
    ParentProfilesCompanion Function({
      Value<String> id,
      Value<String?> authUserId,
      Value<String> displayName,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

class $$ParentProfilesTableFilterComposer
    extends Composer<_$AppDatabase, $ParentProfilesTable> {
  $$ParentProfilesTableFilterComposer({
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

  ColumnFilters<String> get authUserId => $composableBuilder(
    column: $table.authUserId,
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

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ParentProfilesTableOrderingComposer
    extends Composer<_$AppDatabase, $ParentProfilesTable> {
  $$ParentProfilesTableOrderingComposer({
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

  ColumnOrderings<String> get authUserId => $composableBuilder(
    column: $table.authUserId,
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

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ParentProfilesTableAnnotationComposer
    extends Composer<_$AppDatabase, $ParentProfilesTable> {
  $$ParentProfilesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get authUserId => $composableBuilder(
    column: $table.authUserId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get displayName => $composableBuilder(
    column: $table.displayName,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$ParentProfilesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ParentProfilesTable,
          ParentProfile,
          $$ParentProfilesTableFilterComposer,
          $$ParentProfilesTableOrderingComposer,
          $$ParentProfilesTableAnnotationComposer,
          $$ParentProfilesTableCreateCompanionBuilder,
          $$ParentProfilesTableUpdateCompanionBuilder,
          (
            ParentProfile,
            BaseReferences<_$AppDatabase, $ParentProfilesTable, ParentProfile>,
          ),
          ParentProfile,
          PrefetchHooks Function()
        > {
  $$ParentProfilesTableTableManager(
    _$AppDatabase db,
    $ParentProfilesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ParentProfilesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ParentProfilesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ParentProfilesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String?> authUserId = const Value.absent(),
                Value<String> displayName = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ParentProfilesCompanion(
                id: id,
                authUserId: authUserId,
                displayName: displayName,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                Value<String?> authUserId = const Value.absent(),
                required String displayName,
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => ParentProfilesCompanion.insert(
                id: id,
                authUserId: authUserId,
                displayName: displayName,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ParentProfilesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ParentProfilesTable,
      ParentProfile,
      $$ParentProfilesTableFilterComposer,
      $$ParentProfilesTableOrderingComposer,
      $$ParentProfilesTableAnnotationComposer,
      $$ParentProfilesTableCreateCompanionBuilder,
      $$ParentProfilesTableUpdateCompanionBuilder,
      (
        ParentProfile,
        BaseReferences<_$AppDatabase, $ParentProfilesTable, ParentProfile>,
      ),
      ParentProfile,
      PrefetchHooks Function()
    >;
typedef $$ConsentRecordsTableCreateCompanionBuilder =
    ConsentRecordsCompanion Function({
      required String id,
      required String parentId,
      required String status,
      Value<String?> version,
      Value<DateTime?> consentedAt,
      Value<DateTime?> withdrawnAt,
      required DateTime createdAt,
      required DateTime updatedAt,
      Value<int> rowid,
    });
typedef $$ConsentRecordsTableUpdateCompanionBuilder =
    ConsentRecordsCompanion Function({
      Value<String> id,
      Value<String> parentId,
      Value<String> status,
      Value<String?> version,
      Value<DateTime?> consentedAt,
      Value<DateTime?> withdrawnAt,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

class $$ConsentRecordsTableFilterComposer
    extends Composer<_$AppDatabase, $ConsentRecordsTable> {
  $$ConsentRecordsTableFilterComposer({
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

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get version => $composableBuilder(
    column: $table.version,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get consentedAt => $composableBuilder(
    column: $table.consentedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get withdrawnAt => $composableBuilder(
    column: $table.withdrawnAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ConsentRecordsTableOrderingComposer
    extends Composer<_$AppDatabase, $ConsentRecordsTable> {
  $$ConsentRecordsTableOrderingComposer({
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

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get version => $composableBuilder(
    column: $table.version,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get consentedAt => $composableBuilder(
    column: $table.consentedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get withdrawnAt => $composableBuilder(
    column: $table.withdrawnAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ConsentRecordsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ConsentRecordsTable> {
  $$ConsentRecordsTableAnnotationComposer({
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

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<String> get version =>
      $composableBuilder(column: $table.version, builder: (column) => column);

  GeneratedColumn<DateTime> get consentedAt => $composableBuilder(
    column: $table.consentedAt,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get withdrawnAt => $composableBuilder(
    column: $table.withdrawnAt,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$ConsentRecordsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ConsentRecordsTable,
          ConsentRecord,
          $$ConsentRecordsTableFilterComposer,
          $$ConsentRecordsTableOrderingComposer,
          $$ConsentRecordsTableAnnotationComposer,
          $$ConsentRecordsTableCreateCompanionBuilder,
          $$ConsentRecordsTableUpdateCompanionBuilder,
          (
            ConsentRecord,
            BaseReferences<_$AppDatabase, $ConsentRecordsTable, ConsentRecord>,
          ),
          ConsentRecord,
          PrefetchHooks Function()
        > {
  $$ConsentRecordsTableTableManager(
    _$AppDatabase db,
    $ConsentRecordsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ConsentRecordsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ConsentRecordsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ConsentRecordsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> parentId = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<String?> version = const Value.absent(),
                Value<DateTime?> consentedAt = const Value.absent(),
                Value<DateTime?> withdrawnAt = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ConsentRecordsCompanion(
                id: id,
                parentId: parentId,
                status: status,
                version: version,
                consentedAt: consentedAt,
                withdrawnAt: withdrawnAt,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String parentId,
                required String status,
                Value<String?> version = const Value.absent(),
                Value<DateTime?> consentedAt = const Value.absent(),
                Value<DateTime?> withdrawnAt = const Value.absent(),
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => ConsentRecordsCompanion.insert(
                id: id,
                parentId: parentId,
                status: status,
                version: version,
                consentedAt: consentedAt,
                withdrawnAt: withdrawnAt,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ConsentRecordsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ConsentRecordsTable,
      ConsentRecord,
      $$ConsentRecordsTableFilterComposer,
      $$ConsentRecordsTableOrderingComposer,
      $$ConsentRecordsTableAnnotationComposer,
      $$ConsentRecordsTableCreateCompanionBuilder,
      $$ConsentRecordsTableUpdateCompanionBuilder,
      (
        ConsentRecord,
        BaseReferences<_$AppDatabase, $ConsentRecordsTable, ConsentRecord>,
      ),
      ConsentRecord,
      PrefetchHooks Function()
    >;
typedef $$LearnerProfilesTableCreateCompanionBuilder =
    LearnerProfilesCompanion Function({
      required String id,
      required String parentId,
      required String nickname,
      required String avatarId,
      required String ageBand,
      required String language,
      required DateTime createdAt,
      required DateTime updatedAt,
      Value<bool> isDeleted,
      Value<int> rowid,
    });
typedef $$LearnerProfilesTableUpdateCompanionBuilder =
    LearnerProfilesCompanion Function({
      Value<String> id,
      Value<String> parentId,
      Value<String> nickname,
      Value<String> avatarId,
      Value<String> ageBand,
      Value<String> language,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<bool> isDeleted,
      Value<int> rowid,
    });

class $$LearnerProfilesTableFilterComposer
    extends Composer<_$AppDatabase, $LearnerProfilesTable> {
  $$LearnerProfilesTableFilterComposer({
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

  ColumnFilters<String> get nickname => $composableBuilder(
    column: $table.nickname,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get avatarId => $composableBuilder(
    column: $table.avatarId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get ageBand => $composableBuilder(
    column: $table.ageBand,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get language => $composableBuilder(
    column: $table.language,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isDeleted => $composableBuilder(
    column: $table.isDeleted,
    builder: (column) => ColumnFilters(column),
  );
}

class $$LearnerProfilesTableOrderingComposer
    extends Composer<_$AppDatabase, $LearnerProfilesTable> {
  $$LearnerProfilesTableOrderingComposer({
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

  ColumnOrderings<String> get nickname => $composableBuilder(
    column: $table.nickname,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get avatarId => $composableBuilder(
    column: $table.avatarId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get ageBand => $composableBuilder(
    column: $table.ageBand,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get language => $composableBuilder(
    column: $table.language,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isDeleted => $composableBuilder(
    column: $table.isDeleted,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$LearnerProfilesTableAnnotationComposer
    extends Composer<_$AppDatabase, $LearnerProfilesTable> {
  $$LearnerProfilesTableAnnotationComposer({
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

  GeneratedColumn<String> get nickname =>
      $composableBuilder(column: $table.nickname, builder: (column) => column);

  GeneratedColumn<String> get avatarId =>
      $composableBuilder(column: $table.avatarId, builder: (column) => column);

  GeneratedColumn<String> get ageBand =>
      $composableBuilder(column: $table.ageBand, builder: (column) => column);

  GeneratedColumn<String> get language =>
      $composableBuilder(column: $table.language, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<bool> get isDeleted =>
      $composableBuilder(column: $table.isDeleted, builder: (column) => column);
}

class $$LearnerProfilesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $LearnerProfilesTable,
          LearnerProfile,
          $$LearnerProfilesTableFilterComposer,
          $$LearnerProfilesTableOrderingComposer,
          $$LearnerProfilesTableAnnotationComposer,
          $$LearnerProfilesTableCreateCompanionBuilder,
          $$LearnerProfilesTableUpdateCompanionBuilder,
          (
            LearnerProfile,
            BaseReferences<
              _$AppDatabase,
              $LearnerProfilesTable,
              LearnerProfile
            >,
          ),
          LearnerProfile,
          PrefetchHooks Function()
        > {
  $$LearnerProfilesTableTableManager(
    _$AppDatabase db,
    $LearnerProfilesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LearnerProfilesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LearnerProfilesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LearnerProfilesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> parentId = const Value.absent(),
                Value<String> nickname = const Value.absent(),
                Value<String> avatarId = const Value.absent(),
                Value<String> ageBand = const Value.absent(),
                Value<String> language = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<bool> isDeleted = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LearnerProfilesCompanion(
                id: id,
                parentId: parentId,
                nickname: nickname,
                avatarId: avatarId,
                ageBand: ageBand,
                language: language,
                createdAt: createdAt,
                updatedAt: updatedAt,
                isDeleted: isDeleted,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String parentId,
                required String nickname,
                required String avatarId,
                required String ageBand,
                required String language,
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<bool> isDeleted = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LearnerProfilesCompanion.insert(
                id: id,
                parentId: parentId,
                nickname: nickname,
                avatarId: avatarId,
                ageBand: ageBand,
                language: language,
                createdAt: createdAt,
                updatedAt: updatedAt,
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

typedef $$LearnerProfilesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $LearnerProfilesTable,
      LearnerProfile,
      $$LearnerProfilesTableFilterComposer,
      $$LearnerProfilesTableOrderingComposer,
      $$LearnerProfilesTableAnnotationComposer,
      $$LearnerProfilesTableCreateCompanionBuilder,
      $$LearnerProfilesTableUpdateCompanionBuilder,
      (
        LearnerProfile,
        BaseReferences<_$AppDatabase, $LearnerProfilesTable, LearnerProfile>,
      ),
      LearnerProfile,
      PrefetchHooks Function()
    >;
typedef $$ActivityProgressTableCreateCompanionBuilder =
    ActivityProgressCompanion Function({
      required String learnerId,
      required String activityId,
      Value<DateTime?> completedAt,
      Value<int> retryCount,
      Value<int> rowid,
    });
typedef $$ActivityProgressTableUpdateCompanionBuilder =
    ActivityProgressCompanion Function({
      Value<String> learnerId,
      Value<String> activityId,
      Value<DateTime?> completedAt,
      Value<int> retryCount,
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
  ColumnFilters<String> get learnerId => $composableBuilder(
    column: $table.learnerId,
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
  ColumnOrderings<String> get learnerId => $composableBuilder(
    column: $table.learnerId,
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
  GeneratedColumn<String> get learnerId =>
      $composableBuilder(column: $table.learnerId, builder: (column) => column);

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
                Value<String> learnerId = const Value.absent(),
                Value<String> activityId = const Value.absent(),
                Value<DateTime?> completedAt = const Value.absent(),
                Value<int> retryCount = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ActivityProgressCompanion(
                learnerId: learnerId,
                activityId: activityId,
                completedAt: completedAt,
                retryCount: retryCount,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String learnerId,
                required String activityId,
                Value<DateTime?> completedAt = const Value.absent(),
                Value<int> retryCount = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ActivityProgressCompanion.insert(
                learnerId: learnerId,
                activityId: activityId,
                completedAt: completedAt,
                retryCount: retryCount,
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
      required String learnerId,
      required String kind,
      required int amount,
      required String reasonType,
      required String reasonId,
      required String idempotencyKey,
      required DateTime occurredAt,
      Value<int> rowid,
    });
typedef $$RewardTransactionsTableUpdateCompanionBuilder =
    RewardTransactionsCompanion Function({
      Value<String> id,
      Value<String> learnerId,
      Value<String> kind,
      Value<int> amount,
      Value<String> reasonType,
      Value<String> reasonId,
      Value<String> idempotencyKey,
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

  ColumnFilters<String> get learnerId => $composableBuilder(
    column: $table.learnerId,
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

  ColumnFilters<String> get reasonType => $composableBuilder(
    column: $table.reasonType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get reasonId => $composableBuilder(
    column: $table.reasonId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get idempotencyKey => $composableBuilder(
    column: $table.idempotencyKey,
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

  ColumnOrderings<String> get learnerId => $composableBuilder(
    column: $table.learnerId,
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

  ColumnOrderings<String> get reasonType => $composableBuilder(
    column: $table.reasonType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get reasonId => $composableBuilder(
    column: $table.reasonId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get idempotencyKey => $composableBuilder(
    column: $table.idempotencyKey,
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

  GeneratedColumn<String> get learnerId =>
      $composableBuilder(column: $table.learnerId, builder: (column) => column);

  GeneratedColumn<String> get kind =>
      $composableBuilder(column: $table.kind, builder: (column) => column);

  GeneratedColumn<int> get amount =>
      $composableBuilder(column: $table.amount, builder: (column) => column);

  GeneratedColumn<String> get reasonType => $composableBuilder(
    column: $table.reasonType,
    builder: (column) => column,
  );

  GeneratedColumn<String> get reasonId =>
      $composableBuilder(column: $table.reasonId, builder: (column) => column);

  GeneratedColumn<String> get idempotencyKey => $composableBuilder(
    column: $table.idempotencyKey,
    builder: (column) => column,
  );

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
                Value<String> learnerId = const Value.absent(),
                Value<String> kind = const Value.absent(),
                Value<int> amount = const Value.absent(),
                Value<String> reasonType = const Value.absent(),
                Value<String> reasonId = const Value.absent(),
                Value<String> idempotencyKey = const Value.absent(),
                Value<DateTime> occurredAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => RewardTransactionsCompanion(
                id: id,
                learnerId: learnerId,
                kind: kind,
                amount: amount,
                reasonType: reasonType,
                reasonId: reasonId,
                idempotencyKey: idempotencyKey,
                occurredAt: occurredAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String learnerId,
                required String kind,
                required int amount,
                required String reasonType,
                required String reasonId,
                required String idempotencyKey,
                required DateTime occurredAt,
                Value<int> rowid = const Value.absent(),
              }) => RewardTransactionsCompanion.insert(
                id: id,
                learnerId: learnerId,
                kind: kind,
                amount: amount,
                reasonType: reasonType,
                reasonId: reasonId,
                idempotencyKey: idempotencyKey,
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
typedef $$AchievementsTableCreateCompanionBuilder =
    AchievementsCompanion Function({
      required String learnerId,
      required String achievementId,
      required DateTime earnedAt,
      Value<int> rowid,
    });
typedef $$AchievementsTableUpdateCompanionBuilder =
    AchievementsCompanion Function({
      Value<String> learnerId,
      Value<String> achievementId,
      Value<DateTime> earnedAt,
      Value<int> rowid,
    });

class $$AchievementsTableFilterComposer
    extends Composer<_$AppDatabase, $AchievementsTable> {
  $$AchievementsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get learnerId => $composableBuilder(
    column: $table.learnerId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get achievementId => $composableBuilder(
    column: $table.achievementId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get earnedAt => $composableBuilder(
    column: $table.earnedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$AchievementsTableOrderingComposer
    extends Composer<_$AppDatabase, $AchievementsTable> {
  $$AchievementsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get learnerId => $composableBuilder(
    column: $table.learnerId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get achievementId => $composableBuilder(
    column: $table.achievementId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get earnedAt => $composableBuilder(
    column: $table.earnedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$AchievementsTableAnnotationComposer
    extends Composer<_$AppDatabase, $AchievementsTable> {
  $$AchievementsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get learnerId =>
      $composableBuilder(column: $table.learnerId, builder: (column) => column);

  GeneratedColumn<String> get achievementId => $composableBuilder(
    column: $table.achievementId,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get earnedAt =>
      $composableBuilder(column: $table.earnedAt, builder: (column) => column);
}

class $$AchievementsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $AchievementsTable,
          Achievement,
          $$AchievementsTableFilterComposer,
          $$AchievementsTableOrderingComposer,
          $$AchievementsTableAnnotationComposer,
          $$AchievementsTableCreateCompanionBuilder,
          $$AchievementsTableUpdateCompanionBuilder,
          (
            Achievement,
            BaseReferences<_$AppDatabase, $AchievementsTable, Achievement>,
          ),
          Achievement,
          PrefetchHooks Function()
        > {
  $$AchievementsTableTableManager(_$AppDatabase db, $AchievementsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AchievementsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AchievementsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AchievementsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> learnerId = const Value.absent(),
                Value<String> achievementId = const Value.absent(),
                Value<DateTime> earnedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => AchievementsCompanion(
                learnerId: learnerId,
                achievementId: achievementId,
                earnedAt: earnedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String learnerId,
                required String achievementId,
                required DateTime earnedAt,
                Value<int> rowid = const Value.absent(),
              }) => AchievementsCompanion.insert(
                learnerId: learnerId,
                achievementId: achievementId,
                earnedAt: earnedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$AchievementsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $AchievementsTable,
      Achievement,
      $$AchievementsTableFilterComposer,
      $$AchievementsTableOrderingComposer,
      $$AchievementsTableAnnotationComposer,
      $$AchievementsTableCreateCompanionBuilder,
      $$AchievementsTableUpdateCompanionBuilder,
      (
        Achievement,
        BaseReferences<_$AppDatabase, $AchievementsTable, Achievement>,
      ),
      Achievement,
      PrefetchHooks Function()
    >;
typedef $$OwnedAccessoriesTableCreateCompanionBuilder =
    OwnedAccessoriesCompanion Function({
      required String learnerId,
      required String accessoryId,
      required DateTime purchasedAt,
      Value<int> rowid,
    });
typedef $$OwnedAccessoriesTableUpdateCompanionBuilder =
    OwnedAccessoriesCompanion Function({
      Value<String> learnerId,
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
  ColumnFilters<String> get learnerId => $composableBuilder(
    column: $table.learnerId,
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
  ColumnOrderings<String> get learnerId => $composableBuilder(
    column: $table.learnerId,
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
  GeneratedColumn<String> get learnerId =>
      $composableBuilder(column: $table.learnerId, builder: (column) => column);

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
                Value<String> learnerId = const Value.absent(),
                Value<String> accessoryId = const Value.absent(),
                Value<DateTime> purchasedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => OwnedAccessoriesCompanion(
                learnerId: learnerId,
                accessoryId: accessoryId,
                purchasedAt: purchasedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String learnerId,
                required String accessoryId,
                required DateTime purchasedAt,
                Value<int> rowid = const Value.absent(),
              }) => OwnedAccessoriesCompanion.insert(
                learnerId: learnerId,
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
typedef $$EquippedAccessoriesTableCreateCompanionBuilder =
    EquippedAccessoriesCompanion Function({
      required String learnerId,
      required String slot,
      required String accessoryId,
      required DateTime equippedAt,
      Value<int> rowid,
    });
typedef $$EquippedAccessoriesTableUpdateCompanionBuilder =
    EquippedAccessoriesCompanion Function({
      Value<String> learnerId,
      Value<String> slot,
      Value<String> accessoryId,
      Value<DateTime> equippedAt,
      Value<int> rowid,
    });

class $$EquippedAccessoriesTableFilterComposer
    extends Composer<_$AppDatabase, $EquippedAccessoriesTable> {
  $$EquippedAccessoriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get learnerId => $composableBuilder(
    column: $table.learnerId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get slot => $composableBuilder(
    column: $table.slot,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get accessoryId => $composableBuilder(
    column: $table.accessoryId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get equippedAt => $composableBuilder(
    column: $table.equippedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$EquippedAccessoriesTableOrderingComposer
    extends Composer<_$AppDatabase, $EquippedAccessoriesTable> {
  $$EquippedAccessoriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get learnerId => $composableBuilder(
    column: $table.learnerId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get slot => $composableBuilder(
    column: $table.slot,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get accessoryId => $composableBuilder(
    column: $table.accessoryId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get equippedAt => $composableBuilder(
    column: $table.equippedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$EquippedAccessoriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $EquippedAccessoriesTable> {
  $$EquippedAccessoriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get learnerId =>
      $composableBuilder(column: $table.learnerId, builder: (column) => column);

  GeneratedColumn<String> get slot =>
      $composableBuilder(column: $table.slot, builder: (column) => column);

  GeneratedColumn<String> get accessoryId => $composableBuilder(
    column: $table.accessoryId,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get equippedAt => $composableBuilder(
    column: $table.equippedAt,
    builder: (column) => column,
  );
}

class $$EquippedAccessoriesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $EquippedAccessoriesTable,
          EquippedAccessory,
          $$EquippedAccessoriesTableFilterComposer,
          $$EquippedAccessoriesTableOrderingComposer,
          $$EquippedAccessoriesTableAnnotationComposer,
          $$EquippedAccessoriesTableCreateCompanionBuilder,
          $$EquippedAccessoriesTableUpdateCompanionBuilder,
          (
            EquippedAccessory,
            BaseReferences<
              _$AppDatabase,
              $EquippedAccessoriesTable,
              EquippedAccessory
            >,
          ),
          EquippedAccessory,
          PrefetchHooks Function()
        > {
  $$EquippedAccessoriesTableTableManager(
    _$AppDatabase db,
    $EquippedAccessoriesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$EquippedAccessoriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$EquippedAccessoriesTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$EquippedAccessoriesTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> learnerId = const Value.absent(),
                Value<String> slot = const Value.absent(),
                Value<String> accessoryId = const Value.absent(),
                Value<DateTime> equippedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => EquippedAccessoriesCompanion(
                learnerId: learnerId,
                slot: slot,
                accessoryId: accessoryId,
                equippedAt: equippedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String learnerId,
                required String slot,
                required String accessoryId,
                required DateTime equippedAt,
                Value<int> rowid = const Value.absent(),
              }) => EquippedAccessoriesCompanion.insert(
                learnerId: learnerId,
                slot: slot,
                accessoryId: accessoryId,
                equippedAt: equippedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$EquippedAccessoriesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $EquippedAccessoriesTable,
      EquippedAccessory,
      $$EquippedAccessoriesTableFilterComposer,
      $$EquippedAccessoriesTableOrderingComposer,
      $$EquippedAccessoriesTableAnnotationComposer,
      $$EquippedAccessoriesTableCreateCompanionBuilder,
      $$EquippedAccessoriesTableUpdateCompanionBuilder,
      (
        EquippedAccessory,
        BaseReferences<
          _$AppDatabase,
          $EquippedAccessoriesTable,
          EquippedAccessory
        >,
      ),
      EquippedAccessory,
      PrefetchHooks Function()
    >;
typedef $$SyncOutboxTableCreateCompanionBuilder =
    SyncOutboxCompanion Function({
      required String id,
      required String eventId,
      required String operation,
      required String payloadJson,
      required DateTime createdAt,
      Value<int> attempts,
      Value<DateTime?> nextAttemptAt,
      Value<String?> lastError,
      Value<DateTime?> syncedAt,
      Value<int> rowid,
    });
typedef $$SyncOutboxTableUpdateCompanionBuilder =
    SyncOutboxCompanion Function({
      Value<String> id,
      Value<String> eventId,
      Value<String> operation,
      Value<String> payloadJson,
      Value<DateTime> createdAt,
      Value<int> attempts,
      Value<DateTime?> nextAttemptAt,
      Value<String?> lastError,
      Value<DateTime?> syncedAt,
      Value<int> rowid,
    });

class $$SyncOutboxTableFilterComposer
    extends Composer<_$AppDatabase, $SyncOutboxTable> {
  $$SyncOutboxTableFilterComposer({
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

  ColumnFilters<String> get eventId => $composableBuilder(
    column: $table.eventId,
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

  ColumnFilters<DateTime> get nextAttemptAt => $composableBuilder(
    column: $table.nextAttemptAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get lastError => $composableBuilder(
    column: $table.lastError,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get syncedAt => $composableBuilder(
    column: $table.syncedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SyncOutboxTableOrderingComposer
    extends Composer<_$AppDatabase, $SyncOutboxTable> {
  $$SyncOutboxTableOrderingComposer({
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

  ColumnOrderings<String> get eventId => $composableBuilder(
    column: $table.eventId,
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

  ColumnOrderings<DateTime> get nextAttemptAt => $composableBuilder(
    column: $table.nextAttemptAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get lastError => $composableBuilder(
    column: $table.lastError,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get syncedAt => $composableBuilder(
    column: $table.syncedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SyncOutboxTableAnnotationComposer
    extends Composer<_$AppDatabase, $SyncOutboxTable> {
  $$SyncOutboxTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get eventId =>
      $composableBuilder(column: $table.eventId, builder: (column) => column);

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

  GeneratedColumn<DateTime> get nextAttemptAt => $composableBuilder(
    column: $table.nextAttemptAt,
    builder: (column) => column,
  );

  GeneratedColumn<String> get lastError =>
      $composableBuilder(column: $table.lastError, builder: (column) => column);

  GeneratedColumn<DateTime> get syncedAt =>
      $composableBuilder(column: $table.syncedAt, builder: (column) => column);
}

class $$SyncOutboxTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SyncOutboxTable,
          SyncOutboxData,
          $$SyncOutboxTableFilterComposer,
          $$SyncOutboxTableOrderingComposer,
          $$SyncOutboxTableAnnotationComposer,
          $$SyncOutboxTableCreateCompanionBuilder,
          $$SyncOutboxTableUpdateCompanionBuilder,
          (
            SyncOutboxData,
            BaseReferences<_$AppDatabase, $SyncOutboxTable, SyncOutboxData>,
          ),
          SyncOutboxData,
          PrefetchHooks Function()
        > {
  $$SyncOutboxTableTableManager(_$AppDatabase db, $SyncOutboxTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SyncOutboxTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SyncOutboxTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SyncOutboxTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> eventId = const Value.absent(),
                Value<String> operation = const Value.absent(),
                Value<String> payloadJson = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> attempts = const Value.absent(),
                Value<DateTime?> nextAttemptAt = const Value.absent(),
                Value<String?> lastError = const Value.absent(),
                Value<DateTime?> syncedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SyncOutboxCompanion(
                id: id,
                eventId: eventId,
                operation: operation,
                payloadJson: payloadJson,
                createdAt: createdAt,
                attempts: attempts,
                nextAttemptAt: nextAttemptAt,
                lastError: lastError,
                syncedAt: syncedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String eventId,
                required String operation,
                required String payloadJson,
                required DateTime createdAt,
                Value<int> attempts = const Value.absent(),
                Value<DateTime?> nextAttemptAt = const Value.absent(),
                Value<String?> lastError = const Value.absent(),
                Value<DateTime?> syncedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SyncOutboxCompanion.insert(
                id: id,
                eventId: eventId,
                operation: operation,
                payloadJson: payloadJson,
                createdAt: createdAt,
                attempts: attempts,
                nextAttemptAt: nextAttemptAt,
                lastError: lastError,
                syncedAt: syncedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SyncOutboxTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SyncOutboxTable,
      SyncOutboxData,
      $$SyncOutboxTableFilterComposer,
      $$SyncOutboxTableOrderingComposer,
      $$SyncOutboxTableAnnotationComposer,
      $$SyncOutboxTableCreateCompanionBuilder,
      $$SyncOutboxTableUpdateCompanionBuilder,
      (
        SyncOutboxData,
        BaseReferences<_$AppDatabase, $SyncOutboxTable, SyncOutboxData>,
      ),
      SyncOutboxData,
      PrefetchHooks Function()
    >;
typedef $$SyncMetadataTableCreateCompanionBuilder =
    SyncMetadataCompanion Function({
      required String key,
      required String value,
      required DateTime updatedAt,
      Value<int> rowid,
    });
typedef $$SyncMetadataTableUpdateCompanionBuilder =
    SyncMetadataCompanion Function({
      Value<String> key,
      Value<String> value,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

class $$SyncMetadataTableFilterComposer
    extends Composer<_$AppDatabase, $SyncMetadataTable> {
  $$SyncMetadataTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SyncMetadataTableOrderingComposer
    extends Composer<_$AppDatabase, $SyncMetadataTable> {
  $$SyncMetadataTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SyncMetadataTableAnnotationComposer
    extends Composer<_$AppDatabase, $SyncMetadataTable> {
  $$SyncMetadataTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get key =>
      $composableBuilder(column: $table.key, builder: (column) => column);

  GeneratedColumn<String> get value =>
      $composableBuilder(column: $table.value, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$SyncMetadataTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SyncMetadataTable,
          SyncMetadataData,
          $$SyncMetadataTableFilterComposer,
          $$SyncMetadataTableOrderingComposer,
          $$SyncMetadataTableAnnotationComposer,
          $$SyncMetadataTableCreateCompanionBuilder,
          $$SyncMetadataTableUpdateCompanionBuilder,
          (
            SyncMetadataData,
            BaseReferences<_$AppDatabase, $SyncMetadataTable, SyncMetadataData>,
          ),
          SyncMetadataData,
          PrefetchHooks Function()
        > {
  $$SyncMetadataTableTableManager(_$AppDatabase db, $SyncMetadataTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SyncMetadataTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SyncMetadataTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SyncMetadataTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> key = const Value.absent(),
                Value<String> value = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SyncMetadataCompanion(
                key: key,
                value: value,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String key,
                required String value,
                required DateTime updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => SyncMetadataCompanion.insert(
                key: key,
                value: value,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SyncMetadataTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SyncMetadataTable,
      SyncMetadataData,
      $$SyncMetadataTableFilterComposer,
      $$SyncMetadataTableOrderingComposer,
      $$SyncMetadataTableAnnotationComposer,
      $$SyncMetadataTableCreateCompanionBuilder,
      $$SyncMetadataTableUpdateCompanionBuilder,
      (
        SyncMetadataData,
        BaseReferences<_$AppDatabase, $SyncMetadataTable, SyncMetadataData>,
      ),
      SyncMetadataData,
      PrefetchHooks Function()
    >;
typedef $$DeletionRequestsTableCreateCompanionBuilder =
    DeletionRequestsCompanion Function({
      required String id,
      required String target,
      required String status,
      required DateTime requestedAt,
      required DateTime scheduledFor,
      Value<DateTime?> cancelledAt,
      Value<int> rowid,
    });
typedef $$DeletionRequestsTableUpdateCompanionBuilder =
    DeletionRequestsCompanion Function({
      Value<String> id,
      Value<String> target,
      Value<String> status,
      Value<DateTime> requestedAt,
      Value<DateTime> scheduledFor,
      Value<DateTime?> cancelledAt,
      Value<int> rowid,
    });

class $$DeletionRequestsTableFilterComposer
    extends Composer<_$AppDatabase, $DeletionRequestsTable> {
  $$DeletionRequestsTableFilterComposer({
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

  ColumnFilters<String> get target => $composableBuilder(
    column: $table.target,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get requestedAt => $composableBuilder(
    column: $table.requestedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get scheduledFor => $composableBuilder(
    column: $table.scheduledFor,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get cancelledAt => $composableBuilder(
    column: $table.cancelledAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$DeletionRequestsTableOrderingComposer
    extends Composer<_$AppDatabase, $DeletionRequestsTable> {
  $$DeletionRequestsTableOrderingComposer({
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

  ColumnOrderings<String> get target => $composableBuilder(
    column: $table.target,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get requestedAt => $composableBuilder(
    column: $table.requestedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get scheduledFor => $composableBuilder(
    column: $table.scheduledFor,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get cancelledAt => $composableBuilder(
    column: $table.cancelledAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$DeletionRequestsTableAnnotationComposer
    extends Composer<_$AppDatabase, $DeletionRequestsTable> {
  $$DeletionRequestsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get target =>
      $composableBuilder(column: $table.target, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<DateTime> get requestedAt => $composableBuilder(
    column: $table.requestedAt,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get scheduledFor => $composableBuilder(
    column: $table.scheduledFor,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get cancelledAt => $composableBuilder(
    column: $table.cancelledAt,
    builder: (column) => column,
  );
}

class $$DeletionRequestsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $DeletionRequestsTable,
          DeletionRequest,
          $$DeletionRequestsTableFilterComposer,
          $$DeletionRequestsTableOrderingComposer,
          $$DeletionRequestsTableAnnotationComposer,
          $$DeletionRequestsTableCreateCompanionBuilder,
          $$DeletionRequestsTableUpdateCompanionBuilder,
          (
            DeletionRequest,
            BaseReferences<
              _$AppDatabase,
              $DeletionRequestsTable,
              DeletionRequest
            >,
          ),
          DeletionRequest,
          PrefetchHooks Function()
        > {
  $$DeletionRequestsTableTableManager(
    _$AppDatabase db,
    $DeletionRequestsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DeletionRequestsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DeletionRequestsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DeletionRequestsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> target = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<DateTime> requestedAt = const Value.absent(),
                Value<DateTime> scheduledFor = const Value.absent(),
                Value<DateTime?> cancelledAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => DeletionRequestsCompanion(
                id: id,
                target: target,
                status: status,
                requestedAt: requestedAt,
                scheduledFor: scheduledFor,
                cancelledAt: cancelledAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String target,
                required String status,
                required DateTime requestedAt,
                required DateTime scheduledFor,
                Value<DateTime?> cancelledAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => DeletionRequestsCompanion.insert(
                id: id,
                target: target,
                status: status,
                requestedAt: requestedAt,
                scheduledFor: scheduledFor,
                cancelledAt: cancelledAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$DeletionRequestsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $DeletionRequestsTable,
      DeletionRequest,
      $$DeletionRequestsTableFilterComposer,
      $$DeletionRequestsTableOrderingComposer,
      $$DeletionRequestsTableAnnotationComposer,
      $$DeletionRequestsTableCreateCompanionBuilder,
      $$DeletionRequestsTableUpdateCompanionBuilder,
      (
        DeletionRequest,
        BaseReferences<_$AppDatabase, $DeletionRequestsTable, DeletionRequest>,
      ),
      DeletionRequest,
      PrefetchHooks Function()
    >;
typedef $$AppMetadataTableCreateCompanionBuilder =
    AppMetadataCompanion Function({
      required String key,
      required String value,
      required DateTime updatedAt,
      Value<int> rowid,
    });
typedef $$AppMetadataTableUpdateCompanionBuilder =
    AppMetadataCompanion Function({
      Value<String> key,
      Value<String> value,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

class $$AppMetadataTableFilterComposer
    extends Composer<_$AppDatabase, $AppMetadataTable> {
  $$AppMetadataTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$AppMetadataTableOrderingComposer
    extends Composer<_$AppDatabase, $AppMetadataTable> {
  $$AppMetadataTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$AppMetadataTableAnnotationComposer
    extends Composer<_$AppDatabase, $AppMetadataTable> {
  $$AppMetadataTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get key =>
      $composableBuilder(column: $table.key, builder: (column) => column);

  GeneratedColumn<String> get value =>
      $composableBuilder(column: $table.value, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$AppMetadataTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $AppMetadataTable,
          AppMetadataData,
          $$AppMetadataTableFilterComposer,
          $$AppMetadataTableOrderingComposer,
          $$AppMetadataTableAnnotationComposer,
          $$AppMetadataTableCreateCompanionBuilder,
          $$AppMetadataTableUpdateCompanionBuilder,
          (
            AppMetadataData,
            BaseReferences<_$AppDatabase, $AppMetadataTable, AppMetadataData>,
          ),
          AppMetadataData,
          PrefetchHooks Function()
        > {
  $$AppMetadataTableTableManager(_$AppDatabase db, $AppMetadataTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AppMetadataTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AppMetadataTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AppMetadataTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> key = const Value.absent(),
                Value<String> value = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => AppMetadataCompanion(
                key: key,
                value: value,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String key,
                required String value,
                required DateTime updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => AppMetadataCompanion.insert(
                key: key,
                value: value,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$AppMetadataTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $AppMetadataTable,
      AppMetadataData,
      $$AppMetadataTableFilterComposer,
      $$AppMetadataTableOrderingComposer,
      $$AppMetadataTableAnnotationComposer,
      $$AppMetadataTableCreateCompanionBuilder,
      $$AppMetadataTableUpdateCompanionBuilder,
      (
        AppMetadataData,
        BaseReferences<_$AppDatabase, $AppMetadataTable, AppMetadataData>,
      ),
      AppMetadataData,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$ParentProfilesTableTableManager get parentProfiles =>
      $$ParentProfilesTableTableManager(_db, _db.parentProfiles);
  $$ConsentRecordsTableTableManager get consentRecords =>
      $$ConsentRecordsTableTableManager(_db, _db.consentRecords);
  $$LearnerProfilesTableTableManager get learnerProfiles =>
      $$LearnerProfilesTableTableManager(_db, _db.learnerProfiles);
  $$ActivityProgressTableTableManager get activityProgress =>
      $$ActivityProgressTableTableManager(_db, _db.activityProgress);
  $$RewardTransactionsTableTableManager get rewardTransactions =>
      $$RewardTransactionsTableTableManager(_db, _db.rewardTransactions);
  $$AchievementsTableTableManager get achievements =>
      $$AchievementsTableTableManager(_db, _db.achievements);
  $$OwnedAccessoriesTableTableManager get ownedAccessories =>
      $$OwnedAccessoriesTableTableManager(_db, _db.ownedAccessories);
  $$EquippedAccessoriesTableTableManager get equippedAccessories =>
      $$EquippedAccessoriesTableTableManager(_db, _db.equippedAccessories);
  $$SyncOutboxTableTableManager get syncOutbox =>
      $$SyncOutboxTableTableManager(_db, _db.syncOutbox);
  $$SyncMetadataTableTableManager get syncMetadata =>
      $$SyncMetadataTableTableManager(_db, _db.syncMetadata);
  $$DeletionRequestsTableTableManager get deletionRequests =>
      $$DeletionRequestsTableTableManager(_db, _db.deletionRequests);
  $$AppMetadataTableTableManager get appMetadata =>
      $$AppMetadataTableTableManager(_db, _db.appMetadata);
}
