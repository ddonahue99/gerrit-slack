RailsAdmin.config do |config|

  ### Popular gems integration

  ## == Devise ==
  # config.authenticate_with do
  #   warden.authenticate! scope: :user
  # end
  # config.current_user_method(&:current_user)

  ## == Cancan ==
  # config.authorize_with :cancan

  ## == PaperTrail ==
  # config.audit_with :paper_trail, 'User', 'PaperTrail::Version' # PaperTrail >= 3.0.0

  ### More at https://github.com/sferik/rails_admin/wiki/Base-configuration

  config.actions do
    dashboard                     # mandatory
    index                         # mandatory
    new
    export
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
  config.excluded_models << Admin
end