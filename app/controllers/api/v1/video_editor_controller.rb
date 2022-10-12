class Api::V1::VideoEditorController < ApplicationController
  require 'shotstack'

  def index
    shootStack = Shotstack.configure do |config|
      config.api_key['x-api-key'] = ENV['SHOT_STACK_API_KEY']
      config.host = 'api.shotstack.io'
      config.base_path = 'stage'
    end

    images = [
      'https://s3-ap-southeast-2.amazonaws.com/shotstack-assets/examples/images/pexels/pexels-photo-712850.jpeg',
      'https://s3-ap-southeast-2.amazonaws.com/shotstack-assets/examples/images/pexels/pexels-photo-867452.jpeg',
      'https://s3-ap-southeast-2.amazonaws.com/shotstack-assets/examples/images/pexels/pexels-photo-752036.jpeg',
      'https://s3-ap-southeast-2.amazonaws.com/shotstack-assets/examples/images/pexels/pexels-photo-572487.jpeg',
      'https://s3-ap-southeast-2.amazonaws.com/shotstack-assets/examples/images/pexels/pexels-photo-114977.jpeg',
      'https://s3-ap-southeast-2.amazonaws.com/shotstack-assets/examples/images/pexels/pexels-photo-347143.jpeg',
      'https://s3-ap-southeast-2.amazonaws.com/shotstack-assets/examples/images/pexels/pexels-photo-206290.jpeg',
      'https://s3-ap-southeast-2.amazonaws.com/shotstack-assets/examples/images/pexels/pexels-photo-940301.jpeg',
      'https://s3-ap-southeast-2.amazonaws.com/shotstack-assets/examples/images/pexels/pexels-photo-266583.jpeg',
      'https://s3-ap-southeast-2.amazonaws.com/shotstack-assets/examples/images/pexels/pexels-photo-539432.jpeg'
    ]
    api_client = Shotstack::EditApi.new
    soundtrack = Shotstack::Soundtrack.new(
      effect: 'fadeInFadeOut',
      src: 'https://s3-ap-southeast-2.amazonaws.com/shotstack-assets/music/gangsta.mp3'
    )
    clips = []
    start = 0
    length = 1

    images.each_with_index do |image, _index|
      image_asset = Shotstack::ImageAsset.new(src: image)

      clip = Shotstack::Clip.new(
        asset: image_asset,
        length:,
        start:,
        effect: 'zoomIn'
      )

      start += length
      clips.push(clip)
    end

    track1 = Shotstack::Track.new(clips:)
    timeline = Shotstack::Timeline.new(
      background: '#000000',
      soundtrack:,
      tracks: [track1]
    )

    output = Shotstack::Output.new(
      format: 'mp4',
      resolution: 'sd',
      fps: 30,
      destinations: [{
        provider: 's3',
        options: {
          region: 'ap-northeast-1',
          bucket: 'shareandrem-videos'
        }
      }, {
        "provider": 'shotstack',
        "exclude": true
      }]
    )

    edit = Shotstack::Edit.new(
      timeline:,
      output:,
      callback: 'https://webhook.site/5cb3879e-b031-4bac-a7c8-a2f7bf07411b'
    )

    begin
      response = api_client.post_render(edit).response
    rescue StandardError => e
      abort("Request failed: #{e.message}")
    end

    render json: {
      'response' => response,
      'message' => response.message,
      'checkStatusUrl' => "http://localhost:3000/api/v1/video-editor-get-render/#{response.id}"
      # "response id" => "#{response.url}"
    }
  end

  def renderJson(data)
    render json: {
      data:
    }
  end

  def getRender
    videoId = params[:id]
    shootStack = Shotstack.configure do |config|
      config.api_key['x-api-key'] = ENV['SHOT_STACK_API_KEY']
      config.host = 'api.shotstack.io'
      config.base_path = 'stage'
    end

    api_client = Shotstack::EditApi.new
    response = api_client.get_render(videoId, { data: false, merged: true }).response

    render json: {
      'response' => response
    }
  end
end
