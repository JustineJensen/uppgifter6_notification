abstract class Repository<T, ID> {
  Future <T> findById(ID id);
  Future <List <T>> findAll();
  Future <T> add(T entity);
  Future <void> update(T entity);
  Future <void> deleteById(ID id);
}
