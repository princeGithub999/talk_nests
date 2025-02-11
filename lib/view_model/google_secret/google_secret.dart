import 'package:googleapis_auth/auth_io.dart';

class GoogleSecret {
  static Future<String> getServerKey() async {
    final scopes = [
      "https://www.googleapis.com/auth/userinfo.email",
      "https://www.googleapis.com/auth/firebase.database",
      "https://www.googleapis.com/auth/firebase.messaging",
    ];

    final client = await clientViaServiceAccount(
        ServiceAccountCredentials.fromJson({
          "type": "service_account",
          "project_id": "flutterfirebaseauth-439e4",
          "private_key_id": "eb8536e4d37ce2d179180df7845d7af02ff12018",
          "private_key":
              "-----BEGIN PRIVATE KEY-----\nMIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQDAJC8dwcbpF8wx\nBouLyiwR1jjcx58YxxtahZyVGOSVojPoma1O0kxwLe7U6nCUuO4+ZV+kK129q93x\n1tzEvCL6KhSxpF29JlFpt/5m+XqKsow8599LhPPWjdelq5Y/IXsQpBK6NW+lf2Fo\nzvnB+Rnp7iQWJ2curQhDpWj9orV4Iw46lbGJgtKcZWqJMkbrwGQvQgUcPpXwYurF\nNyBo7HN8oe05NaRQiqBJLzh5EY0zaBpDSiuu8AEcDexUTDFwmRKHe3t8RE3TKgtO\nQXK6VoT2bhuuWRAArQF+P6ltEJagB23tydYTsWzycuPKQeywICzGr/tGaloYLpmH\nKYKDb6TTAgMBAAECggEAN0Xxe+jztLhQ2EWevS8CsHrkzrZqUTFt8AOBwO5xS45m\nymHzFjqvHJJKI1vx2Qa+GpsFAXAsPlUDuv9pcPsCQN78JwI2qSQtxXDVsX/RPbcR\nWrAFb28myjDxuUn8JdsW0PmyHXkjzgMv3Xu1I5TqXH5SSUE6kJXcS8F4y4YUGCPU\n9oW0+vDKCapecxE/a2e4RquAUWNbU+K4GHsFfuYIZpIAERTI4JgW7aaMmWGoPJq8\nUOI0Nga2E2K2EXq6iuTf/OndlyZzCQromeGy+Umfp48F37HX/rOp4wNEAMaHTCpb\nArDgx8+uAOJUdNYxPa953gQjIcCfi8BpLY03RUR8oQKBgQD6e5gZ7hTkLlcM1ubQ\n0ADJY598J8/TdmglP6T+yLKd7lW7Ixzvbn5AKwdp5eCtS6U3ipRYJO3FG9p2xZS0\nKuB+3viq0l5oHjjDXniyasx1twFsqrk/ksU3C4VCEGr0Cato8ea59MembJixM97X\nMwAV2KXa4in1mTxH1IHBQ6l3EQKBgQDEX541VDnDG4hXnu+DWjVx/+cKNlyiy0Lj\ndc3nwR66GuLwLItPzDbUPyivqDiNQvTbQiWvy/YzxVAarCGNdpzE5cs5Qq98GSeE\n8uO/aii6WdpoVzSL3OOdOMWiFuLD/sVm1Orsv63h1evwvetmXYuH2A42M1gfyEky\nZj4L+t2FowKBgBFDlX8sBqqXew56fVwlCfjXcfWXtN5JSfJPSar54D28YJJOYD8s\naW04ygEFhA/Np+yFE6ZjnTO5sLwA8DfewKxd59u2NiWM97KXf1AkxkTSwTlhJvV3\nwzoBBEVCZmy9gd/w1Es60MvqrjeAcLp6XGYlEYFdlzDDSAFXZz4P0M1RAoGAYc4B\n3SvK7RsMaB+XyUMntVSwPMzgjJBSCzoESLZN2IFFoDt/U0ox0Lp4SCyvpePAUmf6\nnzklsZlHkVFEENIPuJ1+/1DwWA2rOjNDLXXxPQc9mZQ9bp+gmhDJljZx0Q5WQSYw\nr6O0NfO25Jui38Qdl5YLVgFylbnKgxibNJpItKMCgYEAvLKzWyM1e5gCyb2Oa+sg\nbuSzP93Tmo9wGWO0h4s+c2f3CY1jHih6qMeRcCHn1vyEI7u8KXZQNNAnMyI8C3rB\nQIwa+y1g2exDQA6RqiS380KRvhWvObP3DdGc7H5IqJ4CfpFDMSmiMVJ0kqziiwm1\nIh0pvC+fAbcDmHnr3NeP5xA=\n-----END PRIVATE KEY-----\n",
          "client_email":
              "firebase-adminsdk-721x8@flutterfirebaseauth-439e4.iam.gserviceaccount.com",
          "client_id": "111126666228240691380",
          "auth_uri": "https://accounts.google.com/o/oauth2/auth",
          "token_uri": "https://oauth2.googleapis.com/token",
          "auth_provider_x509_cert_url":
              "https://www.googleapis.com/oauth2/v1/certs",
          "client_x509_cert_url":
              "https://www.googleapis.com/robot/v1/metadata/x509/firebase-adminsdk-721x8%40flutterfirebaseauth-439e4.iam.gserviceaccount.com",
          "universe_domain": "googleapis.com"
        }),
        scopes);
    final serverKey = client.credentials.accessToken.data;
    return serverKey;
  }
}
