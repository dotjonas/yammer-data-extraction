require 'yam'
require 'curb'

class YammerController < ApplicationController
  def auth
#CLIENT_ID HERE!
    @client_id = "gCKEes0ovKzofP9giKQ"
  end

  def success
    code = params[:code]

    #CLIENT_ID HERE!
    client_id = "gCKEes0ovKzofP9giKQ"

    #CLIENT_SECRET HERE!
    client_secret = "zVuD1AecfbrJ5Ih9fyklaIIfHseCHE07luyA4KPXg"

    #REDIRECT_URI HERE
    redirect_uri = "http://ancient-island-1993.herokuapp.com/yammer/success/"

    c = Curl::Easy.perform("https://www.yammer.com/oauth2/access_token.json?client_id="+ client_id +"&client_secret="+ client_secret +"&code=" + code)

    token_string = JSON.parse(c.body_str)

    access_token = token_string["access_token"]["token"]

    # Set to session
    session[:access_token] = access_token

    @full_name = token_string["user"]["full_name"]

    @id = token_string["user"]["id"]

    # Get network names

    yammer_endpoint = 'https://www.yammer.com/api/v1/'
    yam ||= Yam.new(access_token, yammer_endpoint)
    @network_name = yam.get('/networks/current')

    if access_token
      yammer_endpoint = 'https://www.yammer.com/api/v1/'
      yam ||= Yam.new(access_token, yammer_endpoint)

      @groups = yam.get('/groups')

    else
      raise "Ouch!"

    end
  end

  def app
    access_token = session[:access_token]

    if access_token
      yammer_endpoint = 'https://www.yammer.com/api/v1/'
      yam ||= Yam.new(access_token, yammer_endpoint)

      # Get all groups
      @groups = yam.get('/groups/')

      # Get all subscriptions
      @subscriptions = yam.get('/subscriptions')

      user_page = 1

      # Get users based on a group
      @users = yam.get('/users?page='+user_page.to_s)


      users_count = @users.count

      while users_count == 50
        user_page = user_page + 1

        users_next = yam.get('/users?page='+user_page)

        @users = @users + users_next

        users_count = @users.count
       end

      # Get all posts
      @posts = yam.get('/messages')

      post_count = @posts['messages'].count
      post_last = @posts['messages'].last
      post_last_id = post_last['id']

      while post_count == 20
        posts_next = yam.get('/messages?older_than='+post_last_id.to_s)

        @posts["messages"] = @posts["messages"] + posts_next["messages"]

        post_count = posts_next['messages'].count
        post_last = posts_next['messages'].last
        post_last_id = post_last['id']

      end

      # Get all networks
      @networks = yam.get('/networks/current')

      # Test
      # @test = yam.get("/group_memberships/1496545440")

    else
      raise "Ouch!"

    end
  end
end
