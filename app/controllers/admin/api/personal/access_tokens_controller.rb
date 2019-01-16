# frozen_string_literal: true

class Admin::Api::Personal::AccessTokensController < Admin::Api::Personal::BaseController
  # FIXME: make the name :access_token, but then it clashes with :access_token query param. somehow we have to split query and body parameters
  # TODO: This was already an issue in the other endpoint and for this one we probably should fix it now that this endpoint doesn't exist yet :)
  wrap_parameters AccessToken, name: :token

  representer AccessToken

  ##~ sapi = source2swagger.namespace("Account Management API")
  ##~ e = sapi.apis.add
  ##~ e.path = "/admin/api/personal/access_tokens.json"
  ##~ e.responseClass = "access_token"
  #
  ##~ op = e.operations.add
  ##~ op.httpMethod = "POST"
  ##~ op.summary   = "Access Token Create"
  ##~ op.description = "Creates an access token. Make sure to copy your new personal access token now. You will not be able to see it again as it is not stored for security reasons."
  ##~ op.group = "access_token"
  #
  ##~ op.parameters.add :name => "name", :description => "Name of the access token.", :dataType => "string", :required => true, :paramType => "query"
  ##~ op.parameters.add :name => "permission", :description => "Permission of the access token. It must be either 'ro' (read only) or 'rw' (read and write).", :dataType => "string", :required => true, :paramType => "query"
  ##~ op.parameters.add :name => "scopes", :defaultName => "scopes[]", :description => "Scope of the access token. URL-encoded array containing one or more of the possible values values. The possible values are, for a master user [\"account_management\", \"stats\"], and for a tenant user [\"finance\", \"account_management\", \"stats\"]", :dataType => "custom", :allowMultiple => true, :required => true, :paramType => "query"
  #
  ##~ op.parameters.add @parameter_access_token
  #
  def create
    respond_with current_user.access_tokens.create(access_token_params)
  end

  ##~ e = sapi.apis.add
  ##~ e.path = "/admin/api/personal/access_tokens/{id}.json"
  ##~ e.responseClass = "access_token"
  #
  ##~ op            = e.operations.add
  ##~ op.httpMethod = "DELETE"
  ##~ op.summary    = "Access Token Delete"
  ##~ op.description = "Deletes an access token."
  ##~ op.group = "access_token"
  #
  ##~ op.parameters.add :name => "id", :description => "ID or value of the access token.", :dataType => "integer", :paramType => "path", :required => true
  #
  ##~ op.parameters.add @parameter_access_token
  #
  def destroy
    token.destroy
    respond_with token
  end

  ##~ e = sapi.apis.add
  ##~ e.path = "/admin/api/personal/access_tokens/{id}.json"
  ##~ e.responseClass = "access_token"
  #
  ##~ op            = e.operations.add
  ##~ op.httpMethod = "GET"
  ##~ op.summary    = "Access Token Read"
  ##~ op.description = "Shows an access token."
  ##~ op.group = "access_token"
  #
  ##~ op.parameters.add :name => "id", :description => "ID or value of the access token.", :dataType => "integer", :paramType => "path", :required => true
  #
  ##~ op.parameters.add @parameter_access_token
  #
  def show
    respond_with token
  end


  private

  def token
    @token ||= begin
      id_or_value = params[:id]
      scoped_access_tokens = current_user.access_tokens
      scoped_access_tokens.by_value(id_or_value) || scoped_access_tokens.find(id_or_value)
    end
  end

  def access_token_params
    params.require(:token).permit(:name, :permission, scopes: [])
  end
end
