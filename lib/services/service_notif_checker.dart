import 'package:gloymoneymanagement/data/repository/invitation_repository.dart';
import 'package:gloymoneymanagement/services/service_http_client.dart';

class NotifCheckerService {
  static final _repo = InvitationRepository(ServiceHttpClient());

  static Future<bool> hasPendingInvitation() async {
    final result = await _repo.getUserInvitations();
    return result.fold((_) => false, (data) {
      return data.any((inv) => inv.status == 'pending');
    });
  }
}
