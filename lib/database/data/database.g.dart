// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $IdentitiesTable extends Identities
    with TableInfo<$IdentitiesTable, Identity> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $IdentitiesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _usernameMeta = const VerificationMeta(
    'username',
  );
  @override
  late final GeneratedColumn<String> username = GeneratedColumn<String>(
    'username',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _cookiesMeta = const VerificationMeta(
    'cookies',
  );
  @override
  late final GeneratedColumn<String> cookies = GeneratedColumn<String>(
    'cookies',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _userAgentMeta = const VerificationMeta(
    'userAgent',
  );
  @override
  late final GeneratedColumn<String> userAgent = GeneratedColumn<String>(
    'user_agent',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
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
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    username,
    cookies,
    userAgent,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'identities';
  @override
  VerificationContext validateIntegrity(
    Insertable<Identity> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('username')) {
      context.handle(
        _usernameMeta,
        username.isAcceptableOrUnknown(data['username']!, _usernameMeta),
      );
    }
    if (data.containsKey('cookies')) {
      context.handle(
        _cookiesMeta,
        cookies.isAcceptableOrUnknown(data['cookies']!, _cookiesMeta),
      );
    } else if (isInserting) {
      context.missing(_cookiesMeta);
    }
    if (data.containsKey('user_agent')) {
      context.handle(
        _userAgentMeta,
        userAgent.isAcceptableOrUnknown(data['user_agent']!, _userAgentMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Identity map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Identity(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      username: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}username'],
      ),
      cookies: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}cookies'],
      )!,
      userAgent: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}user_agent'],
      ),
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $IdentitiesTable createAlias(String alias) {
    return $IdentitiesTable(attachedDatabase, alias);
  }
}

class Identity extends DataClass implements Insertable<Identity> {
  final int id;
  final String? username;
  final String cookies;
  final String? userAgent;
  final DateTime updatedAt;
  const Identity({
    required this.id,
    this.username,
    required this.cookies,
    this.userAgent,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    if (!nullToAbsent || username != null) {
      map['username'] = Variable<String>(username);
    }
    map['cookies'] = Variable<String>(cookies);
    if (!nullToAbsent || userAgent != null) {
      map['user_agent'] = Variable<String>(userAgent);
    }
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  IdentitiesCompanion toCompanion(bool nullToAbsent) {
    return IdentitiesCompanion(
      id: Value(id),
      username: username == null && nullToAbsent
          ? const Value.absent()
          : Value(username),
      cookies: Value(cookies),
      userAgent: userAgent == null && nullToAbsent
          ? const Value.absent()
          : Value(userAgent),
      updatedAt: Value(updatedAt),
    );
  }

  factory Identity.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Identity(
      id: serializer.fromJson<int>(json['id']),
      username: serializer.fromJson<String?>(json['username']),
      cookies: serializer.fromJson<String>(json['cookies']),
      userAgent: serializer.fromJson<String?>(json['userAgent']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'username': serializer.toJson<String?>(username),
      'cookies': serializer.toJson<String>(cookies),
      'userAgent': serializer.toJson<String?>(userAgent),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  Identity copyWith({
    int? id,
    Value<String?> username = const Value.absent(),
    String? cookies,
    Value<String?> userAgent = const Value.absent(),
    DateTime? updatedAt,
  }) => Identity(
    id: id ?? this.id,
    username: username.present ? username.value : this.username,
    cookies: cookies ?? this.cookies,
    userAgent: userAgent.present ? userAgent.value : this.userAgent,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  Identity copyWithCompanion(IdentitiesCompanion data) {
    return Identity(
      id: data.id.present ? data.id.value : this.id,
      username: data.username.present ? data.username.value : this.username,
      cookies: data.cookies.present ? data.cookies.value : this.cookies,
      userAgent: data.userAgent.present ? data.userAgent.value : this.userAgent,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Identity(')
          ..write('id: $id, ')
          ..write('username: $username, ')
          ..write('cookies: $cookies, ')
          ..write('userAgent: $userAgent, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, username, cookies, userAgent, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Identity &&
          other.id == this.id &&
          other.username == this.username &&
          other.cookies == this.cookies &&
          other.userAgent == this.userAgent &&
          other.updatedAt == this.updatedAt);
}

class IdentitiesCompanion extends UpdateCompanion<Identity> {
  final Value<int> id;
  final Value<String?> username;
  final Value<String> cookies;
  final Value<String?> userAgent;
  final Value<DateTime> updatedAt;
  const IdentitiesCompanion({
    this.id = const Value.absent(),
    this.username = const Value.absent(),
    this.cookies = const Value.absent(),
    this.userAgent = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  IdentitiesCompanion.insert({
    this.id = const Value.absent(),
    this.username = const Value.absent(),
    required String cookies,
    this.userAgent = const Value.absent(),
    this.updatedAt = const Value.absent(),
  }) : cookies = Value(cookies);
  static Insertable<Identity> custom({
    Expression<int>? id,
    Expression<String>? username,
    Expression<String>? cookies,
    Expression<String>? userAgent,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (username != null) 'username': username,
      if (cookies != null) 'cookies': cookies,
      if (userAgent != null) 'user_agent': userAgent,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  IdentitiesCompanion copyWith({
    Value<int>? id,
    Value<String?>? username,
    Value<String>? cookies,
    Value<String?>? userAgent,
    Value<DateTime>? updatedAt,
  }) {
    return IdentitiesCompanion(
      id: id ?? this.id,
      username: username ?? this.username,
      cookies: cookies ?? this.cookies,
      userAgent: userAgent ?? this.userAgent,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (username.present) {
      map['username'] = Variable<String>(username.value);
    }
    if (cookies.present) {
      map['cookies'] = Variable<String>(cookies.value);
    }
    if (userAgent.present) {
      map['user_agent'] = Variable<String>(userAgent.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('IdentitiesCompanion(')
          ..write('id: $id, ')
          ..write('username: $username, ')
          ..write('cookies: $cookies, ')
          ..write('userAgent: $userAgent, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $PreferencesTable extends Preferences
    with TableInfo<$PreferencesTable, Preference> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PreferencesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
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
  @override
  List<GeneratedColumn> get $columns => [name, value];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'preferences';
  @override
  VerificationContext validateIntegrity(
    Insertable<Preference> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('value')) {
      context.handle(
        _valueMeta,
        value.isAcceptableOrUnknown(data['value']!, _valueMeta),
      );
    } else if (isInserting) {
      context.missing(_valueMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {name};
  @override
  Preference map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Preference(
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      value: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}value'],
      )!,
    );
  }

  @override
  $PreferencesTable createAlias(String alias) {
    return $PreferencesTable(attachedDatabase, alias);
  }
}

class Preference extends DataClass implements Insertable<Preference> {
  final String name;
  final String value;
  const Preference({required this.name, required this.value});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['name'] = Variable<String>(name);
    map['value'] = Variable<String>(value);
    return map;
  }

  PreferencesCompanion toCompanion(bool nullToAbsent) {
    return PreferencesCompanion(name: Value(name), value: Value(value));
  }

  factory Preference.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Preference(
      name: serializer.fromJson<String>(json['name']),
      value: serializer.fromJson<String>(json['value']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'name': serializer.toJson<String>(name),
      'value': serializer.toJson<String>(value),
    };
  }

  Preference copyWith({String? name, String? value}) =>
      Preference(name: name ?? this.name, value: value ?? this.value);
  Preference copyWithCompanion(PreferencesCompanion data) {
    return Preference(
      name: data.name.present ? data.name.value : this.name,
      value: data.value.present ? data.value.value : this.value,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Preference(')
          ..write('name: $name, ')
          ..write('value: $value')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(name, value);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Preference &&
          other.name == this.name &&
          other.value == this.value);
}

class PreferencesCompanion extends UpdateCompanion<Preference> {
  final Value<String> name;
  final Value<String> value;
  final Value<int> rowid;
  const PreferencesCompanion({
    this.name = const Value.absent(),
    this.value = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PreferencesCompanion.insert({
    required String name,
    required String value,
    this.rowid = const Value.absent(),
  }) : name = Value(name),
       value = Value(value);
  static Insertable<Preference> custom({
    Expression<String>? name,
    Expression<String>? value,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (name != null) 'name': name,
      if (value != null) 'value': value,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PreferencesCompanion copyWith({
    Value<String>? name,
    Value<String>? value,
    Value<int>? rowid,
  }) {
    return PreferencesCompanion(
      name: name ?? this.name,
      value: value ?? this.value,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (value.present) {
      map['value'] = Variable<String>(value.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PreferencesCompanion(')
          ..write('name: $name, ')
          ..write('value: $value, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $CacheEntriesTable extends CacheEntries
    with TableInfo<$CacheEntriesTable, CacheEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CacheEntriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _storeMeta = const VerificationMeta('store');
  @override
  late final GeneratedColumn<String> store = GeneratedColumn<String>(
    'store',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _cacheKeyMeta = const VerificationMeta(
    'cacheKey',
  );
  @override
  late final GeneratedColumn<String> cacheKey = GeneratedColumn<String>(
    'cache_key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _urlMeta = const VerificationMeta('url');
  @override
  late final GeneratedColumn<String> url = GeneratedColumn<String>(
    'url',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _pathMeta = const VerificationMeta('path');
  @override
  late final GeneratedColumn<String> path = GeneratedColumn<String>(
    'path',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _validTillMeta = const VerificationMeta(
    'validTill',
  );
  @override
  late final GeneratedColumn<DateTime> validTill = GeneratedColumn<DateTime>(
    'valid_till',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _eTagMeta = const VerificationMeta('eTag');
  @override
  late final GeneratedColumn<String> eTag = GeneratedColumn<String>(
    'e_tag',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _sizeMeta = const VerificationMeta('size');
  @override
  late final GeneratedColumn<int> size = GeneratedColumn<int>(
    'size',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _touchedMeta = const VerificationMeta(
    'touched',
  );
  @override
  late final GeneratedColumn<DateTime> touched = GeneratedColumn<DateTime>(
    'touched',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    store,
    cacheKey,
    url,
    path,
    validTill,
    eTag,
    size,
    touched,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'cache_entries';
  @override
  VerificationContext validateIntegrity(
    Insertable<CacheEntry> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('store')) {
      context.handle(
        _storeMeta,
        store.isAcceptableOrUnknown(data['store']!, _storeMeta),
      );
    } else if (isInserting) {
      context.missing(_storeMeta);
    }
    if (data.containsKey('cache_key')) {
      context.handle(
        _cacheKeyMeta,
        cacheKey.isAcceptableOrUnknown(data['cache_key']!, _cacheKeyMeta),
      );
    } else if (isInserting) {
      context.missing(_cacheKeyMeta);
    }
    if (data.containsKey('url')) {
      context.handle(
        _urlMeta,
        url.isAcceptableOrUnknown(data['url']!, _urlMeta),
      );
    } else if (isInserting) {
      context.missing(_urlMeta);
    }
    if (data.containsKey('path')) {
      context.handle(
        _pathMeta,
        path.isAcceptableOrUnknown(data['path']!, _pathMeta),
      );
    } else if (isInserting) {
      context.missing(_pathMeta);
    }
    if (data.containsKey('valid_till')) {
      context.handle(
        _validTillMeta,
        validTill.isAcceptableOrUnknown(data['valid_till']!, _validTillMeta),
      );
    } else if (isInserting) {
      context.missing(_validTillMeta);
    }
    if (data.containsKey('e_tag')) {
      context.handle(
        _eTagMeta,
        eTag.isAcceptableOrUnknown(data['e_tag']!, _eTagMeta),
      );
    }
    if (data.containsKey('size')) {
      context.handle(
        _sizeMeta,
        size.isAcceptableOrUnknown(data['size']!, _sizeMeta),
      );
    }
    if (data.containsKey('touched')) {
      context.handle(
        _touchedMeta,
        touched.isAcceptableOrUnknown(data['touched']!, _touchedMeta),
      );
    } else if (isInserting) {
      context.missing(_touchedMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
    {store, cacheKey},
  ];
  @override
  CacheEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CacheEntry(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      store: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}store'],
      )!,
      cacheKey: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}cache_key'],
      )!,
      url: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}url'],
      )!,
      path: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}path'],
      )!,
      validTill: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}valid_till'],
      )!,
      eTag: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}e_tag'],
      ),
      size: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}size'],
      ),
      touched: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}touched'],
      )!,
    );
  }

  @override
  $CacheEntriesTable createAlias(String alias) {
    return $CacheEntriesTable(attachedDatabase, alias);
  }
}

class CacheEntry extends DataClass implements Insertable<CacheEntry> {
  final int id;
  final String store;
  final String cacheKey;
  final String url;
  final String path;
  final DateTime validTill;
  final String? eTag;
  final int? size;
  final DateTime touched;
  const CacheEntry({
    required this.id,
    required this.store,
    required this.cacheKey,
    required this.url,
    required this.path,
    required this.validTill,
    this.eTag,
    this.size,
    required this.touched,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['store'] = Variable<String>(store);
    map['cache_key'] = Variable<String>(cacheKey);
    map['url'] = Variable<String>(url);
    map['path'] = Variable<String>(path);
    map['valid_till'] = Variable<DateTime>(validTill);
    if (!nullToAbsent || eTag != null) {
      map['e_tag'] = Variable<String>(eTag);
    }
    if (!nullToAbsent || size != null) {
      map['size'] = Variable<int>(size);
    }
    map['touched'] = Variable<DateTime>(touched);
    return map;
  }

  CacheEntriesCompanion toCompanion(bool nullToAbsent) {
    return CacheEntriesCompanion(
      id: Value(id),
      store: Value(store),
      cacheKey: Value(cacheKey),
      url: Value(url),
      path: Value(path),
      validTill: Value(validTill),
      eTag: eTag == null && nullToAbsent ? const Value.absent() : Value(eTag),
      size: size == null && nullToAbsent ? const Value.absent() : Value(size),
      touched: Value(touched),
    );
  }

  factory CacheEntry.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CacheEntry(
      id: serializer.fromJson<int>(json['id']),
      store: serializer.fromJson<String>(json['store']),
      cacheKey: serializer.fromJson<String>(json['cacheKey']),
      url: serializer.fromJson<String>(json['url']),
      path: serializer.fromJson<String>(json['path']),
      validTill: serializer.fromJson<DateTime>(json['validTill']),
      eTag: serializer.fromJson<String?>(json['eTag']),
      size: serializer.fromJson<int?>(json['size']),
      touched: serializer.fromJson<DateTime>(json['touched']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'store': serializer.toJson<String>(store),
      'cacheKey': serializer.toJson<String>(cacheKey),
      'url': serializer.toJson<String>(url),
      'path': serializer.toJson<String>(path),
      'validTill': serializer.toJson<DateTime>(validTill),
      'eTag': serializer.toJson<String?>(eTag),
      'size': serializer.toJson<int?>(size),
      'touched': serializer.toJson<DateTime>(touched),
    };
  }

  CacheEntry copyWith({
    int? id,
    String? store,
    String? cacheKey,
    String? url,
    String? path,
    DateTime? validTill,
    Value<String?> eTag = const Value.absent(),
    Value<int?> size = const Value.absent(),
    DateTime? touched,
  }) => CacheEntry(
    id: id ?? this.id,
    store: store ?? this.store,
    cacheKey: cacheKey ?? this.cacheKey,
    url: url ?? this.url,
    path: path ?? this.path,
    validTill: validTill ?? this.validTill,
    eTag: eTag.present ? eTag.value : this.eTag,
    size: size.present ? size.value : this.size,
    touched: touched ?? this.touched,
  );
  CacheEntry copyWithCompanion(CacheEntriesCompanion data) {
    return CacheEntry(
      id: data.id.present ? data.id.value : this.id,
      store: data.store.present ? data.store.value : this.store,
      cacheKey: data.cacheKey.present ? data.cacheKey.value : this.cacheKey,
      url: data.url.present ? data.url.value : this.url,
      path: data.path.present ? data.path.value : this.path,
      validTill: data.validTill.present ? data.validTill.value : this.validTill,
      eTag: data.eTag.present ? data.eTag.value : this.eTag,
      size: data.size.present ? data.size.value : this.size,
      touched: data.touched.present ? data.touched.value : this.touched,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CacheEntry(')
          ..write('id: $id, ')
          ..write('store: $store, ')
          ..write('cacheKey: $cacheKey, ')
          ..write('url: $url, ')
          ..write('path: $path, ')
          ..write('validTill: $validTill, ')
          ..write('eTag: $eTag, ')
          ..write('size: $size, ')
          ..write('touched: $touched')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    store,
    cacheKey,
    url,
    path,
    validTill,
    eTag,
    size,
    touched,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CacheEntry &&
          other.id == this.id &&
          other.store == this.store &&
          other.cacheKey == this.cacheKey &&
          other.url == this.url &&
          other.path == this.path &&
          other.validTill == this.validTill &&
          other.eTag == this.eTag &&
          other.size == this.size &&
          other.touched == this.touched);
}

class CacheEntriesCompanion extends UpdateCompanion<CacheEntry> {
  final Value<int> id;
  final Value<String> store;
  final Value<String> cacheKey;
  final Value<String> url;
  final Value<String> path;
  final Value<DateTime> validTill;
  final Value<String?> eTag;
  final Value<int?> size;
  final Value<DateTime> touched;
  const CacheEntriesCompanion({
    this.id = const Value.absent(),
    this.store = const Value.absent(),
    this.cacheKey = const Value.absent(),
    this.url = const Value.absent(),
    this.path = const Value.absent(),
    this.validTill = const Value.absent(),
    this.eTag = const Value.absent(),
    this.size = const Value.absent(),
    this.touched = const Value.absent(),
  });
  CacheEntriesCompanion.insert({
    this.id = const Value.absent(),
    required String store,
    required String cacheKey,
    required String url,
    required String path,
    required DateTime validTill,
    this.eTag = const Value.absent(),
    this.size = const Value.absent(),
    required DateTime touched,
  }) : store = Value(store),
       cacheKey = Value(cacheKey),
       url = Value(url),
       path = Value(path),
       validTill = Value(validTill),
       touched = Value(touched);
  static Insertable<CacheEntry> custom({
    Expression<int>? id,
    Expression<String>? store,
    Expression<String>? cacheKey,
    Expression<String>? url,
    Expression<String>? path,
    Expression<DateTime>? validTill,
    Expression<String>? eTag,
    Expression<int>? size,
    Expression<DateTime>? touched,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (store != null) 'store': store,
      if (cacheKey != null) 'cache_key': cacheKey,
      if (url != null) 'url': url,
      if (path != null) 'path': path,
      if (validTill != null) 'valid_till': validTill,
      if (eTag != null) 'e_tag': eTag,
      if (size != null) 'size': size,
      if (touched != null) 'touched': touched,
    });
  }

  CacheEntriesCompanion copyWith({
    Value<int>? id,
    Value<String>? store,
    Value<String>? cacheKey,
    Value<String>? url,
    Value<String>? path,
    Value<DateTime>? validTill,
    Value<String?>? eTag,
    Value<int?>? size,
    Value<DateTime>? touched,
  }) {
    return CacheEntriesCompanion(
      id: id ?? this.id,
      store: store ?? this.store,
      cacheKey: cacheKey ?? this.cacheKey,
      url: url ?? this.url,
      path: path ?? this.path,
      validTill: validTill ?? this.validTill,
      eTag: eTag ?? this.eTag,
      size: size ?? this.size,
      touched: touched ?? this.touched,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (store.present) {
      map['store'] = Variable<String>(store.value);
    }
    if (cacheKey.present) {
      map['cache_key'] = Variable<String>(cacheKey.value);
    }
    if (url.present) {
      map['url'] = Variable<String>(url.value);
    }
    if (path.present) {
      map['path'] = Variable<String>(path.value);
    }
    if (validTill.present) {
      map['valid_till'] = Variable<DateTime>(validTill.value);
    }
    if (eTag.present) {
      map['e_tag'] = Variable<String>(eTag.value);
    }
    if (size.present) {
      map['size'] = Variable<int>(size.value);
    }
    if (touched.present) {
      map['touched'] = Variable<DateTime>(touched.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CacheEntriesCompanion(')
          ..write('id: $id, ')
          ..write('store: $store, ')
          ..write('cacheKey: $cacheKey, ')
          ..write('url: $url, ')
          ..write('path: $path, ')
          ..write('validTill: $validTill, ')
          ..write('eTag: $eTag, ')
          ..write('size: $size, ')
          ..write('touched: $touched')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $IdentitiesTable identities = $IdentitiesTable(this);
  late final $PreferencesTable preferences = $PreferencesTable(this);
  late final $CacheEntriesTable cacheEntries = $CacheEntriesTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    identities,
    preferences,
    cacheEntries,
  ];
}

typedef $$IdentitiesTableCreateCompanionBuilder = IdentitiesCompanion Function({
  Value<int> id,
  Value<String?> username,
  required String cookies,
  Value<String?> userAgent,
  Value<DateTime> updatedAt,
});
typedef $$IdentitiesTableUpdateCompanionBuilder = IdentitiesCompanion Function({
  Value<int> id,
  Value<String?> username,
  Value<String> cookies,
  Value<String?> userAgent,
  Value<DateTime> updatedAt,
});

class $$IdentitiesTableFilterComposer
    extends Composer<_$AppDatabase, $IdentitiesTable> {
  $$IdentitiesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get username => $composableBuilder(
    column: $table.username,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get cookies => $composableBuilder(
    column: $table.cookies,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get userAgent => $composableBuilder(
    column: $table.userAgent,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$IdentitiesTableOrderingComposer
    extends Composer<_$AppDatabase, $IdentitiesTable> {
  $$IdentitiesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get username => $composableBuilder(
    column: $table.username,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get cookies => $composableBuilder(
    column: $table.cookies,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get userAgent => $composableBuilder(
    column: $table.userAgent,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$IdentitiesTableAnnotationComposer
    extends Composer<_$AppDatabase, $IdentitiesTable> {
  $$IdentitiesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get username =>
      $composableBuilder(column: $table.username, builder: (column) => column);

  GeneratedColumn<String> get cookies =>
      $composableBuilder(column: $table.cookies, builder: (column) => column);

  GeneratedColumn<String> get userAgent =>
      $composableBuilder(column: $table.userAgent, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$IdentitiesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $IdentitiesTable,
          Identity,
          $$IdentitiesTableFilterComposer,
          $$IdentitiesTableOrderingComposer,
          $$IdentitiesTableAnnotationComposer,
          $$IdentitiesTableCreateCompanionBuilder,
          $$IdentitiesTableUpdateCompanionBuilder,
          (Identity, BaseReferences<_$AppDatabase, $IdentitiesTable, Identity>),
          Identity,
          PrefetchHooks Function()
        > {
  $$IdentitiesTableTableManager(_$AppDatabase db, $IdentitiesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$IdentitiesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$IdentitiesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$IdentitiesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String?> username = const Value.absent(),
                Value<String> cookies = const Value.absent(),
                Value<String?> userAgent = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => IdentitiesCompanion(
                id: id,
                username: username,
                cookies: cookies,
                userAgent: userAgent,
                updatedAt: updatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String?> username = const Value.absent(),
                required String cookies,
                Value<String?> userAgent = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => IdentitiesCompanion.insert(
                id: id,
                username: username,
                cookies: cookies,
                userAgent: userAgent,
                updatedAt: updatedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$IdentitiesTable, Identity>(table),
                  BaseReferences<_$AppDatabase, $IdentitiesTable, Identity>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$IdentitiesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $IdentitiesTable,
      Identity,
      $$IdentitiesTableFilterComposer,
      $$IdentitiesTableOrderingComposer,
      $$IdentitiesTableAnnotationComposer,
      $$IdentitiesTableCreateCompanionBuilder,
      $$IdentitiesTableUpdateCompanionBuilder,
      (Identity, BaseReferences<_$AppDatabase, $IdentitiesTable, Identity>),
      Identity,
      PrefetchHooks Function()
    >;
typedef $$PreferencesTableCreateCompanionBuilder =
    PreferencesCompanion Function({
      required String name,
      required String value,
      Value<int> rowid,
    });
typedef $$PreferencesTableUpdateCompanionBuilder =
    PreferencesCompanion Function({
      Value<String> name,
      Value<String> value,
      Value<int> rowid,
    });

class $$PreferencesTableFilterComposer
    extends Composer<_$AppDatabase, $PreferencesTable> {
  $$PreferencesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnFilters(column),
  );
}

class $$PreferencesTableOrderingComposer
    extends Composer<_$AppDatabase, $PreferencesTable> {
  $$PreferencesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$PreferencesTableAnnotationComposer
    extends Composer<_$AppDatabase, $PreferencesTable> {
  $$PreferencesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get value =>
      $composableBuilder(column: $table.value, builder: (column) => column);
}

class $$PreferencesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PreferencesTable,
          Preference,
          $$PreferencesTableFilterComposer,
          $$PreferencesTableOrderingComposer,
          $$PreferencesTableAnnotationComposer,
          $$PreferencesTableCreateCompanionBuilder,
          $$PreferencesTableUpdateCompanionBuilder,
          (
            Preference,
            BaseReferences<_$AppDatabase, $PreferencesTable, Preference>,
          ),
          Preference,
          PrefetchHooks Function()
        > {
  $$PreferencesTableTableManager(_$AppDatabase db, $PreferencesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PreferencesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PreferencesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PreferencesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> name = const Value.absent(),
            Value<String> value = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) => PreferencesCompanion(name: name, value: value, rowid: rowid),
          createCompanionCallback:
              ({
                required String name,
                required String value,
                Value<int> rowid = const Value.absent(),
              }) => PreferencesCompanion.insert(
                name: name,
                value: value,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$PreferencesTable, Preference>(table),
                  BaseReferences<_$AppDatabase, $PreferencesTable, Preference>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$PreferencesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PreferencesTable,
      Preference,
      $$PreferencesTableFilterComposer,
      $$PreferencesTableOrderingComposer,
      $$PreferencesTableAnnotationComposer,
      $$PreferencesTableCreateCompanionBuilder,
      $$PreferencesTableUpdateCompanionBuilder,
      (
        Preference,
        BaseReferences<_$AppDatabase, $PreferencesTable, Preference>,
      ),
      Preference,
      PrefetchHooks Function()
    >;
typedef $$CacheEntriesTableCreateCompanionBuilder =
    CacheEntriesCompanion Function({
      Value<int> id,
      required String store,
      required String cacheKey,
      required String url,
      required String path,
      required DateTime validTill,
      Value<String?> eTag,
      Value<int?> size,
      required DateTime touched,
    });
typedef $$CacheEntriesTableUpdateCompanionBuilder =
    CacheEntriesCompanion Function({
      Value<int> id,
      Value<String> store,
      Value<String> cacheKey,
      Value<String> url,
      Value<String> path,
      Value<DateTime> validTill,
      Value<String?> eTag,
      Value<int?> size,
      Value<DateTime> touched,
    });

class $$CacheEntriesTableFilterComposer
    extends Composer<_$AppDatabase, $CacheEntriesTable> {
  $$CacheEntriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get store => $composableBuilder(
    column: $table.store,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get cacheKey => $composableBuilder(
    column: $table.cacheKey,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get url => $composableBuilder(
    column: $table.url,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get path => $composableBuilder(
    column: $table.path,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get validTill => $composableBuilder(
    column: $table.validTill,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get eTag => $composableBuilder(
    column: $table.eTag,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get size => $composableBuilder(
    column: $table.size,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get touched => $composableBuilder(
    column: $table.touched,
    builder: (column) => ColumnFilters(column),
  );
}

class $$CacheEntriesTableOrderingComposer
    extends Composer<_$AppDatabase, $CacheEntriesTable> {
  $$CacheEntriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get store => $composableBuilder(
    column: $table.store,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get cacheKey => $composableBuilder(
    column: $table.cacheKey,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get url => $composableBuilder(
    column: $table.url,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get path => $composableBuilder(
    column: $table.path,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get validTill => $composableBuilder(
    column: $table.validTill,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get eTag => $composableBuilder(
    column: $table.eTag,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get size => $composableBuilder(
    column: $table.size,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get touched => $composableBuilder(
    column: $table.touched,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CacheEntriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $CacheEntriesTable> {
  $$CacheEntriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get store =>
      $composableBuilder(column: $table.store, builder: (column) => column);

  GeneratedColumn<String> get cacheKey =>
      $composableBuilder(column: $table.cacheKey, builder: (column) => column);

  GeneratedColumn<String> get url =>
      $composableBuilder(column: $table.url, builder: (column) => column);

  GeneratedColumn<String> get path =>
      $composableBuilder(column: $table.path, builder: (column) => column);

  GeneratedColumn<DateTime> get validTill =>
      $composableBuilder(column: $table.validTill, builder: (column) => column);

  GeneratedColumn<String> get eTag =>
      $composableBuilder(column: $table.eTag, builder: (column) => column);

  GeneratedColumn<int> get size =>
      $composableBuilder(column: $table.size, builder: (column) => column);

  GeneratedColumn<DateTime> get touched =>
      $composableBuilder(column: $table.touched, builder: (column) => column);
}

class $$CacheEntriesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CacheEntriesTable,
          CacheEntry,
          $$CacheEntriesTableFilterComposer,
          $$CacheEntriesTableOrderingComposer,
          $$CacheEntriesTableAnnotationComposer,
          $$CacheEntriesTableCreateCompanionBuilder,
          $$CacheEntriesTableUpdateCompanionBuilder,
          (
            CacheEntry,
            BaseReferences<_$AppDatabase, $CacheEntriesTable, CacheEntry>,
          ),
          CacheEntry,
          PrefetchHooks Function()
        > {
  $$CacheEntriesTableTableManager(_$AppDatabase db, $CacheEntriesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CacheEntriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CacheEntriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CacheEntriesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> store = const Value.absent(),
                Value<String> cacheKey = const Value.absent(),
                Value<String> url = const Value.absent(),
                Value<String> path = const Value.absent(),
                Value<DateTime> validTill = const Value.absent(),
                Value<String?> eTag = const Value.absent(),
                Value<int?> size = const Value.absent(),
                Value<DateTime> touched = const Value.absent(),
              }) => CacheEntriesCompanion(
                id: id,
                store: store,
                cacheKey: cacheKey,
                url: url,
                path: path,
                validTill: validTill,
                eTag: eTag,
                size: size,
                touched: touched,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String store,
                required String cacheKey,
                required String url,
                required String path,
                required DateTime validTill,
                Value<String?> eTag = const Value.absent(),
                Value<int?> size = const Value.absent(),
                required DateTime touched,
              }) => CacheEntriesCompanion.insert(
                id: id,
                store: store,
                cacheKey: cacheKey,
                url: url,
                path: path,
                validTill: validTill,
                eTag: eTag,
                size: size,
                touched: touched,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$CacheEntriesTable, CacheEntry>(table),
                  BaseReferences<_$AppDatabase, $CacheEntriesTable, CacheEntry>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$CacheEntriesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CacheEntriesTable,
      CacheEntry,
      $$CacheEntriesTableFilterComposer,
      $$CacheEntriesTableOrderingComposer,
      $$CacheEntriesTableAnnotationComposer,
      $$CacheEntriesTableCreateCompanionBuilder,
      $$CacheEntriesTableUpdateCompanionBuilder,
      (
        CacheEntry,
        BaseReferences<_$AppDatabase, $CacheEntriesTable, CacheEntry>,
      ),
      CacheEntry,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$IdentitiesTableTableManager get identities =>
      $$IdentitiesTableTableManager(_db, _db.identities);
  $$PreferencesTableTableManager get preferences =>
      $$PreferencesTableTableManager(_db, _db.preferences);
  $$CacheEntriesTableTableManager get cacheEntries =>
      $$CacheEntriesTableTableManager(_db, _db.cacheEntries);
}
