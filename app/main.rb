def tick(args)

  args.state.card_w ||= 157
  args.state.card_h ||= 189
  args.state.glow_size ||= 10
  args.state.card_angle ||= 0

  args.state.glow_w ||= args.state.card_w + (args.state.glow_size * 2)
  args.state.glow_h ||= args.state.card_h + (args.state.glow_size * 2)

  args.outputs.background_color = [11, 22, 33]

  # render target to house the aura effect
  outer_glow = args.outputs[:glow].sprites
  args.outputs[:glow].w = args.state.glow_w
  args.outputs[:glow].h = args.state.glow_h

  # add a sprite with blurry edges
  # scale the sprite up/down to change the thickness of the effect
  outer_glow << {
    x: 0,
    y: 0,
    w: args.state.glow_w,
    h: args.state.glow_h,
    path: 'sprites/light_glow.png'
  }

  # make a fiery looking texture to use as a moving background
  # texture can be animated by changing the path
  # make this image white on a transparent background and you can recolor it
  args.state.moving_lights ||= {
    x: -500,
    y: -300,
    w: 1280,
    h: 720,
    path: 'sprites/lights.jpg',
    blendmode_enum: 3 # <-- the magic
  }

  # add some movement to the background texture
  # this is basic and you could have fun with this
  # you could create more unpredictability by overlaying two textures
  # with different movements
  args.state.moving_lights.x += args.tick_count.sin
  args.state.moving_lights.y += args.tick_count.cos
  args.state.moving_lights.angle = args.tick_count / 3

  # rotate if the mouse is down
  args.state.card_angle -= 0.4 if args.inputs.mouse.button_left

  # add the the moving background to the effect
  outer_glow << args.state.moving_lights

  # # output the aura
  args.outputs.sprites << {
    x: args.inputs.mouse.x - args.state.glow_size,
    y: args.inputs.mouse.y - args.state.glow_size,
    w: args.state.glow_w,
    h: args.state.glow_h,
    path: :glow,
    angle: args.state.card_angle
  }

  # # output the main sprite
  args.outputs.sprites << {
    x: args.inputs.mouse.x,
    y: args.inputs.mouse.y,
    w: 157,
    h: 189,
    path: 'sprites/card.png',
    angle: args.state.card_angle
  }
end
