RailsAdmin.config do |config|

  ### Popular gems integration

  # == Devise ==
  config.authenticate_with do
    warden.authenticate! scope: :user
  end
  config.current_user_method(&:current_user)

  ## == Cancan ==
  config.authorize_with :cancan
  config.current_user_method &:current_user

  ## == PaperTrail ==
  # config.audit_with :paper_trail, 'User', 'PaperTrail::Version' # PaperTrail >= 3.0.0

  ### More at https://github.com/sferik/rails_admin/wiki/Base-configuration

  config.actions do
    dashboard                     # mandatory
    index                         # mandatory
    new
    bulk_delete
    show
    edit
    delete
    show_in_app

    ## With an audit adapter, you can add:
    # history_index
    # history_show
  end
end

## CONFIG FOR CHANNEL
RailsAdmin.config do |config|
  config.model 'Channel' do
    list do
      field :name do
        label "Name"
      end
      field :projects do
        label "Projects"
      end
      field :owners do
        label "Owners"
      end
      field :emoji_enabled do
        label "Emojis"
      end
    end
    edit do
      field :name do
        required true
      end
      field :projects do
        required true
        label "Projects"
        help "Separate projects by commas"
      end
      field :owners do
        required true
        label "Owners"
        help "Separate owners by commas"
      end
      field :emoji_enabled do
        required true
        label "Emojis"
      end
      field :qa_approved_emojis do
        label "QA approved emojis"
        help "Type in emojis like :yuss: :pug:"
      end
      field :product_approved_emojis do
        label "Product approved emojis"
        help "Type in emojis like :yuss: :pug:"
      end
      field :qa_product_approved_emojis do
        label "QA & Product approved emojis"
        help "Type in emojis like :yuss: :pug:"
      end
      field :merged_emojis do
        label "Merged emojis"
        help "Type in emojis like :yuss: :pug:"
      end
    end
  end
end

## CONFIG FOR ALIAS
RailsAdmin.config do |config|
  config.model 'Alias' do
    list do
      field :gerrit_username
      field :slack_username
      end
    end
end

## CONFIG FOR ADMIN
RailsAdmin.config do |config|
  config.model 'User' do
    list do
      field :email
    end
    edit do
      field :email
      field :password
      field :admin
      field :superadmin
    end
  end
end