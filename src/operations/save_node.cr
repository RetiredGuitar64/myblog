class SaveNode < Node::SaveOperation
  permit_columns name, slug, summary, color, position

  before_save do
    validate_required name, slug, summary, color, position
    validate_uniqueness_of name
    validate_uniqueness_of slug
    validate_format_of color, with: /\A#[0-9a-fA-F]{6}\z/
  end
end
