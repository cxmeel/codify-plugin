return e("ImageButton", {
  AutoButtonColor = false,
  AnchorPoint = Vector2.new(0.5, 0.5),
  AutomaticSize = Enum.AutomaticSize.XY,
  BackgroundColor3 = Color3.fromHex("#3C3C3C"),
  LayoutOrder = 40,
  Position = UDim2.fromScale(0.5, 0.5),
}, {
  padding = e("UIPadding", {
    PaddingBottom = UDim.new(0, 1),
    PaddingLeft = UDim.new(0, 1),
    PaddingRight = UDim.new(0, 1),
    PaddingTop = UDim.new(0, 1),
  }),
  corners = e("UICorner", {
    CornerRadius = UDim.new(0, 4),
  }),
  content = e("Frame", {
    AutomaticSize = Enum.AutomaticSize.XY,
    BackgroundColor3 = Color3.fromHex("#00A2FF"),
    ClipsDescendants = true,
  }, {
    layout = e("UIListLayout", {
      Padding = UDim.new(0, 8),
      FillDirection = Enum.FillDirection.Horizontal,
      HorizontalAlignment = Enum.HorizontalAlignment.Center,
      SortOrder = Enum.SortOrder.LayoutOrder,
      VerticalAlignment = Enum.VerticalAlignment.Center,
    }),
    label = e("TextLabel", {
      Font = Enum.Font.Gotham,
      Text = "Save to Device",
      TextColor3 = Color3.fromHex("#FFFFFF"),
      TextSize = 14,
      TextWrapped = true,
      AutomaticSize = Enum.AutomaticSize.XY,
      BackgroundTransparency = 1,
      LayoutOrder = 20,
    }),
    icon = e("ImageLabel", {
      Image = "rbxassetid://8790650933",
      ImageRectOffset = Vector2.new(4, 24),
      ImageRectSize = Vector2.new(16, 16),
      BackgroundTransparency = 1,
      LayoutOrder = 10,
      Size = UDim2.fromOffset(16, 16),
    }),
    padding1 = e("UIPadding", {
      PaddingBottom = UDim.new(0, 8),
      PaddingLeft = UDim.new(0, 8),
      PaddingRight = UDim.new(0, 8),
      PaddingTop = UDim.new(0, 8),
    }),
    corners1 = e("UICorner", {
      CornerRadius = UDim.new(0, 3),
    }),
  }),
})