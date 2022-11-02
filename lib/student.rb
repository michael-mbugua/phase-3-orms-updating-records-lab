require_relative "../config/environment.rb"

class Student
  attr_accessor : name:, grade:

  # Remember, you can access your database connection anywhere in this class
  #  with DB[:conn]
    def initialize(id:nil, name:, grade:)
      @id=id
      @name=name
      @grade=grade
    end
    def self.create_table
      sql =<<-SQL
      CREATE TABLE IF NOT EXISTS students(id INTEGER PRIMARY KEY,
      name TEXT,
      grade TEXT)
      SQL
      DB[:conn].execute(sql)
    end
    def self.drop_table
      sql="DROP TABLE IF EXISTS students"
      DB[:conn].execute(sql)
    end
    def save
      if self.id
        self.update
      else
        sql= <<-SQL
        INSERT INTO students (name ,grade) VALUES(?,?)
        SQL
        DB[:conn].execute(sql,self.name,self.grade)
        self.id=DB[:conn].execute(SELECT last_insert_rowid() FROM students)[0][0]
    end
    def self.create
      student=Student.new(name:name grade:grade)
      student.save
    end
    def self.new_from_db(row)
      self.new(id: row[0], name: row[1], grade: row[2])
  end
  def self.find_by_name
    sql= <<-SQL
    SELECT * FROM students WHERE name=?
    LIMIT 1
    SQL
    row=DB[:conn].execute(sql,name).first
    if row
      self.new_from_db
    else
      self.create(name:name)
  end
  def update
    sql= <<-SQL
    UPDATE students
    SET 
    name = ?,
    WHERE id = ?;
    SQL
    DB[:conn].execute(sql, self.name,  self.id)
  end

end
