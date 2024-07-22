class CloudStorageException implements Exception {
  const CloudStorageException();
}
class CloudNotCreatNoteException extends CloudStorageException{}

class CloudNotGetALLNotesException extends CloudStorageException{}


class CloudNotUpdateNoteException extends CloudStorageException{}

class CloudNotDeleteAllNotesException extends CloudStorageException{}



