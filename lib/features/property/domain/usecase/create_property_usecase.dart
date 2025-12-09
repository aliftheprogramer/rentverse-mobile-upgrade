import '../entity/list_property_entity.dart';
import '../entity/create_property_params.dart';
import '../repository/property_repository.dart';

class CreatePropertyUseCase {
  final PropertyRepository _repository;

  CreatePropertyUseCase(this._repository);

  Future<PropertyEntity> call(CreatePropertyParams params) {
    return _repository.createProperty(params);
  }
}
