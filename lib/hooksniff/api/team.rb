# frozen_string_literal: true

module HookSniff
  class Team
    def initialize(client)
      @client = client
    end

    def list
      @client.execute_request("GET", "/v1/teams")
    end

    def get(id)
      @client.execute_request("GET", "/v1/teams/#{id}")
    end

    def create(attrs)
      @client.execute_request("POST", "/v1/teams", body: attrs)
    end

    def accept_invite(attrs)
      @client.execute_request("POST", "/v1/teams/accept-invite", body: attrs)
    end

    def invite(team_id, attrs)
      @client.execute_request("POST", "/v1/teams/#{team_id}/invite", body: attrs)
    end

    def list_members(team_id)
      @client.execute_request("GET", "/v1/teams/#{team_id}/members")
    end

    def remove_member(team_id, user_id)
      @client.execute_request("DELETE", "/v1/teams/#{team_id}/members/#{user_id}")
      nil
    end

    def change_role(team_id, user_id, attrs)
      @client.execute_request("PUT", "/v1/teams/#{team_id}/members/#{user_id}/role", body: attrs)
    end
  end
end
