import '../../../../domain/usecases/schools/load_school_grades.dart';
import '../../../../infra/repositories/schools/remote_load_school_grades_usecase.dart';
import '../../http/http_factories.dart';

LoadSchoolGradesUsecase makeRemoteLoadSchoolGrades() =>
    RemoteLoadSchoolGradesUsecase(
      httpClient: makeAuthorizeHttpClientDecorator(),
    );
