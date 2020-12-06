import 'package:genshindb/common/enums/app_language_type.dart';

import 'enums/material_type.dart';

class Assets {
  static String dbPath = 'assets/db.json';
  static String translationsBasePath = 'assets/i18n';

  //General
  static String artifactsBasePath = 'assets/artifacts';
  static String charactersBasePath = 'assets/characters';
  static String characterFullBasePath = 'assets/characters_full';
  static String skillsBasePath = 'assets/skills';

  //Weapons
  static String weaponsBasePath = 'assets/weapons';
  static String bowsBasePath = '$weaponsBasePath/bows';
  static String catalystBasePath = '$weaponsBasePath/catalysts';
  static String claymoresBasePath = '$weaponsBasePath/claymores';
  static String polearmsBasePath = '$weaponsBasePath/polearms';
  static String swordsBasePath = '$weaponsBasePath/swords';

  //Items
  static String itemsBasePath = 'assets/items';
  static String commonBasePath = '$itemsBasePath/common';
  static String elementalBasePath = '$itemsBasePath/elemental';
  static String jewelsBasePath = '$itemsBasePath/jewels';
  static String localBasePath = '$itemsBasePath/local';
  static String talentBasePath = '$itemsBasePath/talents';
  static String weaponBasePath = '$itemsBasePath/weapon';
  static String weaponPrimaryBasePath = '$itemsBasePath/weapon_primary';
  static String currencyBasePath = '$itemsBasePath/currency';

  static String getArtifactPath(String name) => '$artifactsBasePath/$name';
  static String getCharacterPath(String name) => '$charactersBasePath/$name';
  static String getCharacterFullPath(String name) => '$characterFullBasePath/$name';
  static String getSkillPath(String name) => '$skillsBasePath/$name';

  static String getBowPath(String name) => '$bowsBasePath/$name';
  static String getCatalystPath(String name) => '$catalystBasePath/$name';
  static String getClaymorePath(String name) => '$claymoresBasePath/$name';
  static String getPolearmPath(String name) => '$polearmsBasePath/$name';
  static String getSwordPath(String name) => '$swordsBasePath/$name';

  static String getCommonMaterialPath(String name) => '$commonBasePath/$name';
  static String getElementalMaterialPath(String name) => '$elementalBasePath/$name';
  static String getJewelMaterialPath(String name) => '$jewelsBasePath/$name';
  static String getLocalMaterialPath(String name) => '$localBasePath/$name';
  static String getTalentMaterialPath(String name) => '$talentBasePath/$name';
  static String getWeaponMaterialPath(String name) => '$weaponBasePath/$name';
  static String getWeaponPrimaryMaterialPath(String name) => '$weaponPrimaryBasePath/$name';
  static String getCurrencyMaterialPath(String name) => '$currencyBasePath/$name';

  static String getMaterialPath(String name, MaterialType type) {
    switch (type) {
      case MaterialType.common:
        return getCommonMaterialPath(name);
      case MaterialType.currency:
        return getCurrencyMaterialPath(name);
      case MaterialType.elemental:
        return getElementalMaterialPath(name);
      case MaterialType.jewels:
        return getJewelMaterialPath(name);
      case MaterialType.local:
        return getLocalMaterialPath(name);
      case MaterialType.talents:
        return getTalentMaterialPath(name);
      case MaterialType.weapon:
        return getWeaponMaterialPath(name);
      case MaterialType.weaponPrimary:
        return getWeaponMaterialPath(name);
      default:
        throw Exception('Invalid material type = $type');
    }
  }

  static String getTranslationPath(AppLanguageType languageType) {
    switch (languageType) {
      case AppLanguageType.english:
        return '$translationsBasePath/en.json';
      case AppLanguageType.spanish:
        return '$translationsBasePath/en.json';
      default:
        throw Exception('Invalid language = $languageType');
    }
  }
}
