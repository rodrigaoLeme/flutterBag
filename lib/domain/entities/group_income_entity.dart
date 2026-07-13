class PropertyEntity {
  final String? id;
  final int? assetTypeId;
  final double? assetAmount;
  final double? installmentAmount;

  const PropertyEntity({
    this.id,
    this.assetTypeId,
    this.assetAmount,
    this.installmentAmount,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'assetTypeId': assetTypeId,
        'assetAmount': assetAmount,
        'installmentAmount': installmentAmount,
      };

  factory PropertyEntity.fromJson(Map<String, dynamic> json) => PropertyEntity(
        id: json['id'] as String?,
        assetTypeId: json['assetTypeId'] as int?,
        assetAmount: (json['assetAmount'] as num?)?.toDouble(),
        installmentAmount: (json['installmentAmount'] as num?)?.toDouble(),
      );
}

class FinancingEntity {
  final String? id;
  final int? assetTypeId;
  final double? assetAmount;

  const FinancingEntity({
    this.id,
    this.assetTypeId,
    this.assetAmount,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'assetTypeId': assetTypeId,
        'assetAmount': assetAmount,
      };

  factory FinancingEntity.fromJson(Map<String, dynamic> json) =>
      FinancingEntity(
        id: json['id'] as String?,
        assetTypeId: json['assetTypeId'] as int?,
        assetAmount: (json['assetAmount'] as num?)?.toDouble(),
      );
}

class VehicleEntity {
  final String? id;
  final String? vehicleBrand;
  final String? vehicleModel;
  final String? vehicleYear;
  final double? assetAmount;
  final double? installmentAmount;

  const VehicleEntity({
    this.id,
    this.vehicleBrand,
    this.vehicleModel,
    this.vehicleYear,
    this.assetAmount,
    this.installmentAmount,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'vehicleBrand': vehicleBrand,
        'vehicleModel': vehicleModel,
        'vehicleYear': vehicleYear,
        'assetAmount': assetAmount,
        'installmentAmount': installmentAmount,
      };

  factory VehicleEntity.fromJson(Map<String, dynamic> json) => VehicleEntity(
        id: json['id'] as String?,
        vehicleBrand: json['vehicleBrand'] as String?,
        vehicleModel: json['vehicleModel'] as String?,
        vehicleYear: json['vehicleYear'] as String?,
        assetAmount: (json['assetAmount'] as num?)?.toDouble(),
        installmentAmount: (json['installmentAmount'] as num?)?.toDouble(),
      );
}

class GroupIncomeEntity {
  final bool? hasRentalPropertyValues;
  final double? propertysAmount;
  final int? financialHelpType;
  final double? financialHelpAmount;
  final String? financialHelper;
  final bool? isGovernmentBeneficiary;
  final String? governmentProgramDescription;
  final double? governmentProgramAmount;
  final bool? hasProprietys;
  final bool? hasFinancing;
  final bool? hasVehicles;
  final List<PropertyEntity> properties;
  final List<FinancingEntity> financings;
  final List<VehicleEntity> vehicles;

  const GroupIncomeEntity({
    this.hasRentalPropertyValues,
    this.propertysAmount,
    this.financialHelpType,
    this.financialHelpAmount,
    this.financialHelper,
    this.isGovernmentBeneficiary,
    this.governmentProgramDescription,
    this.governmentProgramAmount,
    this.hasProprietys,
    this.hasFinancing,
    this.hasVehicles,
    this.properties = const [],
    this.financings = const [],
    this.vehicles = const [],
  });

  Map<String, dynamic> toJson() => {
        'hasRentalPropertyValues': hasRentalPropertyValues,
        'propertysAmount': propertysAmount,
        'financialHelpType': financialHelpType,
        'financialHelpAmount': financialHelpAmount,
        'financialHelper': financialHelper,
        'isGovernmentBeneficiary': isGovernmentBeneficiary,
        'governmentProgramDescription': governmentProgramDescription,
        'governmentProgramAmount': governmentProgramAmount,
        'hasProprietys': hasProprietys,
        'hasFinancing': hasFinancing,
        'hasVehicles': hasVehicles,
        'properties': properties.map((e) => e.toJson()).toList(),
        'financings': financings.map((e) => e.toJson()).toList(),
        'vehicles': vehicles.map((e) => e.toJson()).toList(),
      };

  factory GroupIncomeEntity.fromJson(Map<String, dynamic> json) =>
      GroupIncomeEntity(
        hasRentalPropertyValues: json['hasRentalPropertyValues'] as bool?,
        propertysAmount: (json['propertysAmount'] as num?)?.toDouble(),
        financialHelpType: json['financialHelpType'] as int?,
        financialHelpAmount: (json['financialHelpAmount'] as num?)?.toDouble(),
        financialHelper: json['financialHelper'] as String?,
        isGovernmentBeneficiary: json['isGovernmentBeneficiary'] as bool?,
        governmentProgramDescription:
            json['governmentProgramDescription'] as String?,
        governmentProgramAmount:
            (json['governmentProgramAmount'] as num?)?.toDouble(),
        hasProprietys: json['hasProprietys'] as bool?,
        hasFinancing: json['hasFinancing'] as bool?,
        hasVehicles: json['hasVehicles'] as bool?,
        properties: (json['properties'] as List?)
                ?.map((e) => PropertyEntity.fromJson(
                    Map<String, dynamic>.from(e as Map)))
                .toList() ??
            [],
        financings: (json['financings'] as List?)
                ?.map((e) => FinancingEntity.fromJson(
                    Map<String, dynamic>.from(e as Map)))
                .toList() ??
            [],
        vehicles: (json['vehicles'] as List?)
                ?.map((e) =>
                    VehicleEntity.fromJson(Map<String, dynamic>.from(e as Map)))
                .toList() ??
            [],
      );
}
