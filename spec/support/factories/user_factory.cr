class UserFactory < Avram::Factory
  def initialize
    name sequence("Name")
    email "#{sequence("test-email")}@example.com"
    encrypted_password Authentic.generate_encrypted_password("password")
  end
end
