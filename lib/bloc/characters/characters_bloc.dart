import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../common/enums/character_filter_type.dart';
import '../../common/enums/element_type.dart';
import '../../common/enums/released_unreleased_type.dart';
import '../../common/enums/sort_direction_type.dart';
import '../../common/enums/weapon_type.dart';
import '../../models/models.dart';
import '../../services/genshing_service.dart';

part 'characters_bloc.freezed.dart';
part 'characters_event.dart';
part 'characters_state.dart';

class CharactersBloc extends Bloc<CharactersEvent, CharactersState> {
  final GenshinService _genshinService;
  CharactersBloc(this._genshinService) : super(const CharactersState.loading());

  _LoadedState get currentState => state as _LoadedState;

  @override
  Stream<CharactersState> mapEventToState(
    CharactersEvent event,
  ) async* {
    final s = event.map(
      init: (_) => _buildInitialState(),
      characterFilterTypeChanged: (e) => currentState.copyWith.call(tempCharacterFilterType: e.characterFilterType),
      elementTypeChanged: (e) {
        var types = <ElementType>[];
        if (currentState.tempElementTypes.contains(e.elementType)) {
          types = currentState.tempElementTypes.where((t) => t != e.elementType).toList();
        } else {
          types = currentState.tempElementTypes + [e.elementType];
        }
        return currentState.copyWith.call(tempElementTypes: types);
      },
      rarityChanged: (e) => currentState.copyWith.call(tempRarity: e.rarity),
      releasedUnreleasedTypeChanged: (e) => currentState.copyWith.call(
        tempReleasedUnreleasedType: e.releasedUnreleasedType,
      ),
      sortDirectionTypeChanged: (e) => currentState.copyWith.call(tempSortDirectionType: e.sortDirectionType),
      weaponTypeChanged: (e) {
        var types = <WeaponType>[];
        if (currentState.tempWeaponTypes.contains(e.weaponType)) {
          types = currentState.tempWeaponTypes.where((t) => t != e.weaponType).toList();
        } else {
          types = currentState.tempWeaponTypes + [e.weaponType];
        }
        return currentState.copyWith.call(tempWeaponTypes: types);
      },
      searchChanged: (e) => _buildInitialState(
        search: e.search,
        characterFilterType: currentState.characterFilterType,
        elementTypes: currentState.elementTypes,
        rarity: currentState.rarity,
        releasedUnreleasedType: currentState.releasedUnreleasedType,
        sortDirectionType: currentState.sortDirectionType,
        weaponTypes: currentState.weaponTypes,
      ),
      applyFilterChanges: (_) => _buildInitialState(
        search: currentState.search,
        characterFilterType: currentState.tempCharacterFilterType,
        elementTypes: currentState.tempElementTypes,
        rarity: currentState.tempRarity,
        releasedUnreleasedType: currentState.tempReleasedUnreleasedType,
        sortDirectionType: currentState.tempSortDirectionType,
        weaponTypes: currentState.tempWeaponTypes,
      ),
      cancelChanges: (_) => currentState.copyWith.call(
        tempCharacterFilterType: currentState.characterFilterType,
        tempElementTypes: currentState.elementTypes,
        tempRarity: currentState.rarity,
        tempReleasedUnreleasedType: currentState.releasedUnreleasedType,
        tempSortDirectionType: currentState.sortDirectionType,
        tempWeaponTypes: currentState.weaponTypes,
      ),
    );
    yield s;
  }

//TODO: FALTA UN DELAY EN EL SEARCH
  CharactersState _buildInitialState({
    String search,
    List<WeaponType> weaponTypes = const [],
    List<ElementType> elementTypes = const [],
    int rarity = 0,
    ReleasedUnreleasedType releasedUnreleasedType = ReleasedUnreleasedType.all,
    CharacterFilterType characterFilterType = CharacterFilterType.name,
    SortDirectionType sortDirectionType = SortDirectionType.asc,
  }) {
    final isLoaded = state is _LoadedState;
    var characters = _genshinService.getCharactersForCard();

    if (!isLoaded) {
      final selectedWeaponTypes = WeaponType.values.toList();
      final selectedElementTypes = ElementType.values.toList();
      return CharactersState.loaded(
        characters: characters,
        search: search,
        weaponTypes: selectedWeaponTypes,
        tempWeaponTypes: selectedWeaponTypes,
        elementTypes: selectedElementTypes,
        tempElementTypes: selectedElementTypes,
        rarity: rarity,
        tempRarity: rarity,
        releasedUnreleasedType: releasedUnreleasedType,
        tempReleasedUnreleasedType: releasedUnreleasedType,
        characterFilterType: characterFilterType,
        tempCharacterFilterType: characterFilterType,
        sortDirectionType: sortDirectionType,
        tempSortDirectionType: sortDirectionType,
      );
    }

    if (search != null && search.isNotEmpty) {
      characters = characters.where((el) => el.name.toLowerCase().contains(search.toLowerCase())).toList();
    }

    if (rarity > 0) {
      characters = characters.where((el) => el.stars == rarity).toList();
    }

    if (weaponTypes.isNotEmpty) {
      characters = characters.where((el) => weaponTypes.contains(el.weaponType)).toList();
    }

    if (elementTypes.isNotEmpty) {
      characters = characters.where((el) => elementTypes.contains(el.elementType)).toList();
    }

    switch (releasedUnreleasedType) {
      case ReleasedUnreleasedType.released:
        characters = characters.where((el) => !el.isComingSoon).toList();
        break;
      case ReleasedUnreleasedType.unreleased:
        characters = characters.where((el) => el.isComingSoon).toList();
        break;
      default:
        break;
    }

    switch (characterFilterType) {
      case CharacterFilterType.name:
        if (sortDirectionType == SortDirectionType.asc) {
          characters.sort((x, y) => x.name.compareTo(y.name));
        } else {
          characters.sort((x, y) => y.name.compareTo(x.name));
        }
        break;
      case CharacterFilterType.rarity:
        if (sortDirectionType == SortDirectionType.asc) {
          characters.sort((x, y) => x.stars.compareTo(y.stars));
        } else {
          characters.sort((x, y) => y.stars.compareTo(x.stars));
        }
        break;
      default:
        break;
    }

    final s = currentState.copyWith.call(
      characters: characters,
      search: search,
      weaponTypes: weaponTypes,
      tempWeaponTypes: weaponTypes,
      elementTypes: elementTypes,
      tempElementTypes: elementTypes,
      rarity: rarity,
      tempRarity: rarity,
      releasedUnreleasedType: releasedUnreleasedType,
      tempReleasedUnreleasedType: releasedUnreleasedType,
      characterFilterType: characterFilterType,
      tempCharacterFilterType: characterFilterType,
      sortDirectionType: sortDirectionType,
      tempSortDirectionType: sortDirectionType,
    );
    return s;
  }
}
