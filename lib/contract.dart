import 'package:flutter/services.dart' show rootBundle;
import 'package:http/src/client.dart';
import 'package:web3dart/web3dart.dart';
import 'package:trust_blockchain/global_variable.dart';

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

String PrivateKey = Eth_Private_Key;
String Address = Contract_Address;

EthPrivateKey credentials = EthPrivateKey.fromHex(PrivateKey);

Future<void> connectToEthereum() async {
  String abiJson = await rootBundle.loadString('assets/abi.json');
  String contractAddress = Address;

  contract = DeployedContract(ContractAbi.fromJson(abiJson, 'ContractName'),
      EthereumAddress.fromHex(contractAddress));

  createNoteFunction = contract.function('createNoteWithId');
  getNoteCountFunction = contract.function('getNoteCount');
  getNoteByIdFunction = contract.function('getNotesById');
  updateNoteByIndexFunction = contract.function('updateNoteByIndex');
  deleteNoteByIndexFunction = contract.function('deleteNoteByIndex');

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

Future<void> updateNoteByIndex(String uid, int index, String title, String content) async {
  await ethClient.sendTransaction(
    credentials,
    Transaction.callContract(
      contract: contract,
      function: updateNoteByIndexFunction,
      parameters: [uid, BigInt.from(index), title, content],
    ),
    chainId: 11155111,
  );
}

Future<void> deleteNoteByIndex(int index) async {
  if (index >= 0 && index < notes.length) {
    await ethClient.sendTransaction(
      credentials,
      Transaction.callContract(
        contract: contract,
        function: deleteNoteByIndexFunction,
        parameters: [BigInt.from(index)],
      ),
      chainId: 11155111,
    );

  } else {
    print('Invalid index');
  }
}
