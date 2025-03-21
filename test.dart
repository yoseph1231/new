import 'dart:io';
import 'dart:math';

class Character {
  String name;
  int health;
  int attackPower;
  int defense;

  Character(this.name, this.health, this.attackPower, this.defense);

  void showStatus() {
    print('$name - 체력: $health, 공격력: $attackPower, 방어력: $defense');
  }
}

class Monster {
  String name;
  int health;
  int attackPower;

  Monster(this.name, this.health, this.attackPower);

  void showStatus() {
    print('$name - 체력: $health, 공격력: $attackPower');
  }
}

class Game {
  late Character player;
  List<Monster> monsters = [];
  Random random = Random();

  void loadCharacter() {
    try {
      final file = File('characters.txt');
      final contents = file.readAsStringSync().trim();
      final stats = contents.split(',');

      if (stats.length != 3) throw FormatException('캐릭터 데이터 오류');

      print('캐릭터 이름을 입력하세요:');
      String name = stdin.readLineSync()!.trim();
      if (!RegExp(r'^[a-zA-Z가-힣]+$').hasMatch(name)) {
        print('잘못된 이름입니다. 한글 또는 영문만 입력하세요.');
        return;
      }

      player = Character(name, int.parse(stats[0]), int.parse(stats[1]), int.parse(stats[2]));
      print('\n게임을 시작합니다!');
      player.showStatus();
    } catch (e) {
      print('캐릭터 정보를 불러오지 못했습니다: $e');
      exit(1);
    }
  }

  void loadMonsters() {
    try {
      final file = File('monsters.txt');
      final contents = file.readAsLinesSync();
      
      for (var line in contents) {
        var stats = line.split(',');
        if (stats.length != 3) continue;
        monsters.add(Monster(stats[0], int.parse(stats[1]), int.parse(stats[2])));
      }
    } catch (e) {
      print('몬스터 정보를 불러오지 못했습니다: $e');
      exit(1);
    }
  }

  void saveResult(bool isWin) {
    print('결과를 저장하시겠습니까? (y/n)');
    String? input = stdin.readLineSync()?.trim().toLowerCase();
    if (input == 'y') {
      try {
        final file = File('result.txt');
        file.writeAsStringSync('${player.name}, ${player.health}, ${isWin ? '승리' : '패배'}');
        print('결과가 저장되었습니다!');
      } catch (e) {
        print('결과 저장 실패: $e');
      }
    }
  }

  void startGame() {
    loadCharacter();
    loadMonsters();
    
    for (var monster in monsters) {
      print('\n새로운 몬스터가 나타났습니다!');
      monster.showStatus();
      
      while (player.health > 0 && monster.health > 0) {
        print('\n${player.name}의 턴');
        print('행동을 선택하세요 (1: 공격, 2: 방어):');
        String? action = stdin.readLineSync()?.trim();
        
        if (action == '1') {
          monster.health -= player.attackPower;
          print('${player.name}이(가) ${monster.name}에게 ${player.attackPower}의 데미지를 입혔습니다.');
        } else if (action == '2') {
          int recovered = min(player.defense, monster.attackPower);
          player.health += recovered;
          print('${player.name}이(가) 방어하여 ${recovered}만큼 체력을 회복했습니다.');
        }

        if (monster.health > 0) {
          int damage = max(monster.attackPower - player.defense, 0);
          player.health -= damage;
          print('${monster.name}이(가) ${player.name}에게 ${damage}의 데미지를 입혔습니다.');
        }
      }
      
      if (player.health <= 0) {
        print('\n패배했습니다.');
        saveResult(false);
        return;
      }
      print('${monster.name}을(를) 물리쳤습니다!');
    }
    
    print('\n축하합니다! 모든 몬스터를 물리쳤습니다!');
    saveResult(true);
  }
}

void main() {
  Game game = Game();
  game.startGame();
}
