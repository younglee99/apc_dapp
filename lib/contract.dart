import 'package:flutter/services.dart' show rootBundle;
import 'package:http/src/client.dart';
import 'package:web3dart/web3dart.dart';

class Note {
  String title;
  String imageURL;

  Note({
    required this.title,
    required this.imageURL,
  });
}

List<Note> notes = [];

late Client httpClient;
late Web3Client ethClient;
late EthereumAddress contractAddress;
late DeployedContract contract;
late ContractFunction createNoteFunction;
late ContractFunction getNoteCountFunction;
late ContractFunction getNoteByIdFunction;
late ContractFunction updateNoteByIndexFunction;
late ContractFunction deleteNoteByIndexFunction;
late int noteCount;

EthPrivateKey credentials = EthPrivateKey.fromHex(
    "f5bd22493d75c67e7ff8fc8c4769c1cbbe0126db1dd0b2ba37eaeae319deae47");

Future<void> connectToEthereum() async {
  String abiJson = await rootBundle.loadString('assets/abi.json');
  String contractAddress = "0x15bf5EeB1A3947d4F37A6BD23Ca3fA445efF40C7";

  contract = DeployedContract(ContractAbi.fromJson(abiJson, 'ContractName'),
      EthereumAddress.fromHex(contractAddress));

  createNoteFunction = contract.function('createNoteWithId');
  getNoteCountFunction = contract.function('getNoteCount');
  getNoteByIdFunction = contract.function('getNotesById');
}

Future<void> createNote(String uid, String title, String content) async {
  await ethClient.sendTransaction(
    credentials,
    Transaction.callContract(
      contract: contract,
      function: createNoteFunction,
      parameters: [uid, title, content],
    ),
    chainId: 11155111,
  );
}
