class Matrix<T extends num>{
  late List<List<T>> _matr;
  int _columns;
  int _rows;

  int get colums => _columns;
  int get rows => _rows;

  Matrix(this._rows, this._columns, T value){
    List<T> matrRows = <T>[];
    List<List<T>> matrLines = <List<T>>[];
    for(int i = 0 ; i<_columns; i++){
      matrRows.add(value);
    }
    for(int i = 0 ; i<_rows; i++){
      matrLines.add(List.from(matrRows));
    }
    this._matr = matrLines;
  }


  Matrix<T> operator +(Matrix<T> other) {
    if(_rows == other._rows && _columns == other._columns){
      Matrix<T> tmpmatr = Matrix(_rows, _columns, _zero(T));
      for(int i = 0; i < _rows; i++){
        List<T> matrColumns = _matr[i];
        for(int j = 0; j < _columns; j++){
          tmpmatr.setValue(i, j, matrColumns[j]+other.getValue(i, j) as T);
        }
      }
      return tmpmatr;
    }else{
      throw Exception("Different matrix sizes");
    }
  }

  Matrix<T> operator *(Matrix<T> other) {
    if(_columns == other._rows){
      Matrix<T> tmpmatr = Matrix(_rows, other._columns, _zero(T));
      for(int i = 0; i < _rows; i++){
        List<T> matrColumns = _matr[i];
        for(int j = 0; j < other._columns; j++){
          dynamic sum = _zero(T);
          for(int p = 0; p < _columns; p++){
            sum += matrColumns[p]*other.getValue(p, j);
          }
          tmpmatr.setValue(i, j, sum as T);
        }
      }
      return tmpmatr;
    }else{
      throw Exception("Different matrix sizes");
    }
  }

  Matrix<T> multByNum(T value){
    Matrix<T> tmpmatr = Matrix(_rows, _columns, _zero(T));
    for(int i = 0; i < _rows; i++){
      List<T> matrColumns = _matr[i];
      for(int j = 0; j < _columns; j++){
        tmpmatr.setValue(i, j, matrColumns[j]*value as T);
      }
    }
    return tmpmatr;
  }


  dynamic _zero(Type t){
    switch(t) {
      case int: return 0;
      case double: return 0.0;
    }
  }


  setValue(int row, int column, T value){
    if(row < _rows && column < _columns){
      List<T> line = _matr[row];
      line[column] = value;
    }else{
      throw Exception("Incorrect matrix element");
    }
  }

  T getValue(int row, int column){
    if(row < _rows && column < _columns){
      List<T> line = _matr[row];
      return line[column];
    }else{
      throw Exception("Incorrect matrix element");
    }
  }


  String toString(){
    String marts = "";
    for(List<T> line in _matr){
      String linematr = "";
      for(T value in line){
        linematr += value.toString()+"  ";
      }
      marts+=linematr+"\n";
    }
    return marts;
  }

  Matrix<double> toDouble(){
    Matrix<double> temp = Matrix(_rows, _columns, 0.0);
    for(int i = 0; i < _rows; i++){
      List<T> matrColumns = _matr[i];
      for(int j = 0; j < _columns; j++){
        temp.setValue(i, j, matrColumns[j].toDouble());
      }
    }
    return temp;
  }

  void show(){
    print("\n  row $_rows col $_columns");
    print("*"*_columns*3);
    print(toString());
  }

}

class SquareMatrix<T extends num> extends Matrix{

  int _dimension;

  int get dimensions => _dimension;

  SquareMatrix(this._dimension, T value): super(_dimension, _dimension, value);

  T determinant(){
    return _matrixDet(this, _dimension);
  }

  T _matrixDet(SquareMatrix matrix, int size) {
    dynamic det = _zero(T);
    int degree = 1;


    if(size == 1) {
      return matrix.getValue(0, 0) as T;
    }

    else if(size == 2) {
      return matrix.getValue(0, 0) *matrix.getValue(1, 1) - matrix.getValue(0, 1)*matrix.getValue(1, 0) as T;
    } else {

      SquareMatrix newMatrix;

      for(int j = 0; j < size; j++) {

        newMatrix = _matrWithoutRowCol(matrix, size, 0, j);


        det = det + (degree * matrix.getValue(0, j) * _matrixDet(newMatrix, size-1));

        degree = -degree;
      }

    }

    return det;
  }

  SquareMatrix _matrWithoutRowCol(SquareMatrix matrix, int dim, int row, int col){
    SquareMatrix resMatrix = SquareMatrix(dim, _zero(T));
    int offsetRow =0;
    int offsetCol =0;
    for(int i = 0; i < dim-1; i++) {

      if(i == row) {
        offsetRow = 1;
      }

      offsetCol = 0;
      for(int j = 0; j < dim-1; j++) {

        if(j == col) {
          offsetCol = 1;
        }

        resMatrix.setValue(i, j, matrix.getValue(i+offsetRow,j + offsetCol) as T);
      }
    }
    return resMatrix;
  }

}