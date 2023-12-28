-- // Variables
local HttpService = game:GetService("HttpService")
local TextService = game:GetService("TextService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local LocalPlayer = game:GetService("Players").LocalPlayer

local _setclipboard = clonefunction(setclipboard);

local Function = {}
local Library = {}
local Utility = {}
local Settings = {
  Themes = {
    ["Default"] = {
      text = Color3.fromRGB(238, 238, 240),
      muted = Color3.fromRGB(79,79,86),
      background = Color3.fromRGB(25, 25, 25),
      primary = Color3.fromRGB(15, 15, 15),
      secondary = Color3.fromRGB(30, 30, 30),
      accent = Color3.fromRGB(10, 10, 10),
      stroke = Color3.fromRGB(50, 50, 50),
      activeColor = Color3.fromRGB(104,255,160),
      errorColor = Color3.fromRGB(255,96,96),
    },
    ["Purple"] = {
      text = Color3.fromRGB(238, 238, 240),
      muted = Color3.fromRGB(79,79,86),
      background = Color3.fromRGB(30, 30, 45),
      primary = Color3.fromRGB(40, 40, 60),
      secondary = Color3.fromRGB(60, 60, 80),
      accent = Color3.fromRGB(60, 60, 80),
      stroke = Color3.fromRGB(60, 60, 80),
      activeColor = Color3.fromRGB(96,255,150),
      errorColor = Color3.fromRGB(255,96,96),
    },
    ["XDie"] = {
      text = Color3.fromRGB(238, 238, 240),
      muted = Color3.fromRGB(79,79,86),
      background = Color3.fromRGB(0, 0, 0),
      primary = Color3.fromRGB(18, 18, 18),
      secondary = Color3.fromRGB(60, 60, 80),
      accent = Color3.fromRGB(0, 0, 0),
      stroke = Color3.fromRGB(60, 60, 60),
      activeColor = Color3.fromRGB(40, 40, 60),
      errorColor = Color3.fromRGB(255,96,96),
    }
  },
  SelectedTheme = "Default",
}
local Minimized = false

-- // Utility Functions
do
function Function:Tween(object, goal, callback)
  local TweenInfo = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut)
  local Tween = TweenService:Create(object, TweenInfo, goal)
  Tween.Completed:Connect(callback or function() end)
  Tween:Play()
end
function Function:Draggable(gui)
	local dragging
	local dragInput
	local dragStart
	local startPos
	local function update(input)
		local delta = input.Position - dragStart
		gui.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
	end
	gui.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = true
			dragStart = input.Position
			startPos = gui.Position
			input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then
					dragging = false
				end
			end)
		end
	end)
	gui.InputChanged:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
			dragInput = input
		end
	end)
	UserInputService.InputChanged:Connect(function(input)
		if input == dragInput and dragging then
			update(input)
		end
	end)
end
function Function:DestroyUI()
  if CoreGui:FindFirstChild("hikariCheat") ~= nil then
    CoreGui:FindFirstChild("hikariCheat"):Destroy()
  elseif gethui():FindFirstChild("hikariCheat") ~= nil then
    gethui():FindFirstChild("hikariCheat"):Destroy()
  end
end
Function:DestroyUI()
end

-- // Library Function
function Library:create(className, properties)
    local inst = Instance.new(className)
    for i, v in next, properties do
      inst[i] = v
    end
    return inst
end

function Library:MakeGUI()
  do
    Utility["GUI"] = Library:create("ScreenGui", {
      DisplayOrder = 11, 
      IgnoreGuiInset = true, 
      Name = "hikariCheat", 
      Parent = CoreGui,
      ResetOnSpawn = false
    })
    Utility["Hide"] = Library:create("Frame", {
      Name = "Toggle",
      AnchorPoint = Vector2.new(0.5,0),
      Position = UDim2.new(0.5, 0, 0, 0),
      BackgroundTransparency = 1,
      Parent = Utility["GUI"],
      BorderSizePixel = 0,
      Size = UDim2.new(0, 40, 1, 0)
    })
    Utility["Main"] = Library:create("Frame", {
      Name = "hikariMain",
      BorderSizePixel = 0,
      AnchorPoint = Vector2.new(0.5, 0.5),
      Position = UDim2.new(0.5, 0, 0.5, 0),
      Size = UDim2.new(0, 350, 0, 200),
      Parent = Utility["GUI"],
      BackgroundColor3 = Settings.Themes[Settings.SelectedTheme].background,
    })
    
    Utility["ImageToggle"] = Library:create("ImageButton", {
      Name = "ConsoleButton",
      Parent = Utility["Hide"],
      BackgroundTransparency = 0.2,
      AnchorPoint = Vector2.new(1, 0),
      BackgroundColor3 = Color3.fromRGB(45, 45, 45),
      BorderColor3 = Color3.fromRGB(0, 0, 0),
      BorderSizePixel = 0,
      Image = "rbxassetid://15762452703",
      Position = UDim2.new(0, 0, 1, 0),
      Size = UDim2.new(0, 32, 0, 32),
    })
    Library:create("UICorner", {
      Parent = Utility["Hide"],
      CornerRadius = UDim.new(0, 5)
    })
    
    Utility["TabContainer"] = Library:create("Frame", {
      Name = "container",
      AnchorPoint = Vector2.new(1, 0),
      BorderSizePixel = 0,
      Position = UDim2.new(1, 0.5, 0, 0),
      Size = UDim2.new(1, -11-110, 1, 0),
      BackgroundColor3 = Settings.Themes[Settings.SelectedTheme].primary,
      BackgroundTransparency = 0.5,
      Parent = Utility["Main"]
    })
    Library:create("UIStroke", {
      Color = Settings.Themes[Settings.SelectedTheme].stroke,
      Thickness = 1,
      Parent = Utility["TabContainer"]
    })
    Library:create("UIPadding", {
      PaddingTop = UDim.new(0, 1),
      PaddingBottom = UDim.new(0, 1),
      PaddingLeft = UDim.new(0, 1),
      PaddingRight = UDim.new(0, 1),
      Parent = Utility["TabContainer"]
    })
    
    Library:create("UIStroke", {
      Color = Settings.Themes[Settings.SelectedTheme].stroke,
      Thickness = 1,
      Parent = Utility["Main"]
    })
    
    Function:Draggable(Utility["Main"])
    
    Utility["ImageToggle"].MouseButton1Up:Connect(function()
      if Minimized then
        Utility["Main"].Enabled = false
      else
        Utility["Main"].Enabled = true
      end
      Minimized = not Minimized
    end)
    
  end
  do
    Utility["Navigation"] = Library:create("Frame", {
      Name = "navigation",
      BorderSizePixel = 0,
      Position = UDim2.new(0, 0, 0, 0),
      Size = UDim2.new(0, 120, 1, 0),
      BackgroundColor3 = Settings.Themes[Settings.SelectedTheme].primary,
      BackgroundTransparency = 0.5,
      Parent = Utility["Main"]
    })
    Utility["Holder"] = Library:create("ScrollingFrame", {
      Name = "Holder",
      BackgroundTransparency = 1,
      BorderSizePixel = 0,
      Position = UDim2.new(0, 0, 0, 42),
      Size = UDim2.new(1, 0, 1, -43),
      ClipsDescendants = true,
      ScrollBarThickness = 0,
      Parent = Utility["Navigation"]
    })
    Utility["Executor"] = Library:create("Frame", {
      Name = "Executor",
      BorderSizePixel = 0,
      Size = UDim2.new(1, 0, 0, 40),
      BackgroundColor3 = Settings.Themes[Settings.SelectedTheme].primary,
      BackgroundTransparency = 1,
      Parent = Utility["Navigation"]
    })
    Library:create("Frame", {
      Name = "line",
      BorderSizePixel = 0,
      AnchorPoint = Vector2.new(0, 1),
      Size = UDim2.new(1, 0, 0, 1),
      Position = UDim2.new(0, 0, 1, 0),
      Parent = Utility["Executor"],
      BackgroundColor3 = Settings.Themes[Settings.SelectedTheme].stroke,
    })
    Library:create("TextLabel", {
      Name = "Title",
      AnchorPoint = Vector2.new(0.5, 0.5),
      Position = UDim2.new(0.5, 0, 0.5, -5),
      BackgroundTransparency = 1,
      Font = Enum.Font.GothamBlack,
      TextColor3 = Settings.Themes[Settings.SelectedTheme].text,
      TextSize = 15,
      Text = "HikariShit",
      Parent = Utility["Executor"]
    })
    Library:create("TextLabel", {
      Name = "SubTitle",
      AnchorPoint = Vector2.new(0.5, 0.5),
      Position = UDim2.new(0.5, 0, 0.5, 6),
      BackgroundTransparency = 1,
      Font = Enum.Font.GothamBold,
      TextColor3 = Settings.Themes[Settings.SelectedTheme].activeColor,
      TextSize = 10,
      Text = "Executor",
      Parent = Utility["Executor"]
    })
    Library:create("UIPadding", {
      PaddingTop = UDim.new(0, 8),
      PaddingBottom = UDim.new(0, 8),
      Parent = Utility["Holder"]
    })
    Library:create("UIListLayout", {
      Padding = UDim.new(0, 3),
      HorizontalAlignment = Enum.HorizontalAlignment.Center,
      SortOrder = Enum.SortOrder.LayoutOrder,
      Parent = Utility["Holder"]
    })
    Library:create("UIStroke", {
      Color = Settings.Themes[Settings.SelectedTheme].stroke,
      Thickness = 1,
      Parent = Utility["Navigation"]
    })
  end
  do
    Utility["TabContent"] = Library:create("Frame", {
      Name = "Colokoy",
      BackgroundTransparency = 1,
      Size = UDim2.new(1, 0, 1, 0),
      BorderSizePixel = 0,
      Parent = Utility["TabContainer"],
      Visible = true
    })
    Library:create("UIPadding", {
      PaddingTop = UDim.new(0, 10),
      PaddingBottom = UDim.new(0, 10),
      PaddingLeft = UDim.new(0, 10),
      PaddingRight = UDim.new(0, 10),
      Parent = Utility["TabContent"]
     })
    Library:create("UIListLayout", {
      Padding = UDim.new(0, 3),
      HorizontalAlignment = Enum.HorizontalAlignment.Center,
      SortOrder = Enum.SortOrder.LayoutOrder,
      Parent = Utility["TabContent"]
    })
    
    Utility["TextBox"] = Library:create("TextBox", {
      Name = "TexyNox",
      TextColor3 = Color3.fromHex("b2b2b2"), 
			TextSize = 11,
			TextTruncate = Enum.TextTruncate.AtEnd,
			TextWrap = true,
			TextWrapped = true,
			MultiLine = true,
			ClearTextOnFocus = false,
			FontFace = Font.new("rbxasset://fonts/families/Ubuntu.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal),
			TextXAlignment = Enum.TextXAlignment.Left, 
			TextYAlignment = Enum.TextYAlignment.Top,
      Size = UDim2.new(1, 0, 1, 0),
      AnchorPoint = Vector2.new(1, 0, 1, 0),
      Text = "",
      PlaceholderText = "print('hello, world')",
      BackgroundTransparency = 1,
      Parent = Utility["TabContent"]
    })
  end
  do
    Utility["ExecuteButton"] = Library:create("Frame", {
      Name = "ExecuteButton",
      BorderSizePixel = 0,
      Size = UDim2.new(1, 0, 0, 30),
      BackgroundColor3 = Settings.Themes[Settings.SelectedTheme].primary,
      BackgroundTransparency = 0.5,
      Parent = Utility["Holder"]
    })
    Utility["ExecuteLabel"] = Library:create("TextLabel", {
      Name = "Title",
      AnchorPoint = Vector2.new(0.5, 0.5),
      Position = UDim2.new(0.5, 0, 0.5, 0),
      BackgroundTransparency = 1,
      Font = Enum.Font.GothamBold,
      TextColor3 = Settings.Themes[Settings.SelectedTheme].text,
      TextSize = 10,
      Text = "Execute",
      TextXAlignment = Enum.TextXAlignment.Center,
      Parent = Utility["ExecuteButton"]
    })
    Library:create("UIStroke", {
      Name = 'Stroke',
      Color = Settings.Themes[Settings.SelectedTheme].stroke,
      Thickness = 0.6,
      Parent = Utility["ExecuteButton"]
    })
    
    Library:create("UIPadding", {
      PaddingRight = UDim.new(0, 5),
      PaddingLeft = UDim.new(0, 5),
      Parent = Utility["Holder"]
    })
    
    Utility["CopyButton"] = Library:create("Frame", {
      Name = "PasteButton",
      BorderSizePixel = 0,
      Size = UDim2.new(1, 0, 0, 30),
      BackgroundColor3 = Settings.Themes[Settings.SelectedTheme].primary,
      BackgroundTransparency = 0.5,
      Parent = Utility["Holder"]
    })
    Utility["CopyLabel"] = Library:create("TextLabel", {
      Name = "Title",
      AnchorPoint = Vector2.new(0.5, 0.5),
      Position = UDim2.new(0.5, 0, 0.5, 0),
      BackgroundTransparency = 1,
      Font = Enum.Font.GothamBold,
      TextColor3 = Settings.Themes[Settings.SelectedTheme].text,
      TextSize = 10,
      Text = "Copy",
      TextXAlignment = Enum.TextXAlignment.Center,
      Parent = Utility["CopyButton"]
    })
    Library:create("UIStroke", {
      Name = 'Stroke',
      Color = Settings.Themes[Settings.SelectedTheme].stroke,
      Thickness = 0.6,
      Parent = Utility["CopyButton"]
    })
    
    Utility["ClearButton"] = Library:create("Frame", {
      Name = "ClearButton",
      BorderSizePixel = 0,
      Size = UDim2.new(1, 0, 0, 30),
      BackgroundColor3 = Settings.Themes[Settings.SelectedTheme].primary,
      BackgroundTransparency = 0.5,
      Parent = Utility["Holder"]
    })
    Utility["ClearLabel"] = Library:create("TextLabel", {
      Name = "Title",
      AnchorPoint = Vector2.new(0.5, 0.5),
      Position = UDim2.new(0.5, 0, 0.5, 0),
      BackgroundTransparency = 1,
      Font = Enum.Font.GothamBold,
      TextColor3 = Settings.Themes[Settings.SelectedTheme].text,
      TextSize = 10,
      Text = "Clear",
      TextXAlignment = Enum.TextXAlignment.Center,
      Parent = Utility["ClearButton"]
    })
    Library:create("UIStroke", {
      Name = 'Stroke',
      Color = Settings.Themes[Settings.SelectedTheme].stroke,
      Thickness = 0.6,
      Parent = Utility["ClearButton"]
    })
    
    Utility["ExecuteButton"].InputBegan:Connect(function(input)
      if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        local Code = Utility["TextBox"].Text
        
        if Code then
          local Func, Error = mb_schedscript(Code) or loadstring(Code)
          if not Func then 
            warn(Error)
          else
            task.spawn(Func)
          end
          Function:Tween(Utility["ExecuteButton"].Stroke, {Color = Settings.Themes[Settings.SelectedTheme].activeColor})
          wait(.5)
          Function:Tween(Utility["ExecuteButton"].Stroke, {Color = Settings.Themes[Settings.SelectedTheme].stroke})
        else
          warn("No text")
          Function:Tween(Utility["ExecuteButton"].Stroke, {Color = Settings.Themes[Settings.SelectedTheme].errorColor})
          wait(.5)
          Function:Tween(Utility["ExecuteButton"].Stroke, {Color = Settings.Themes[Settings.SelectedTheme].stroke})
        end
      end
    end)
    Utility["CopyButton"].InputBegan:Connect(function(input)
      if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        local Code = Utility["TextBox"]
        
        if Code.Text then
          _setclipboard(Code.Text)
          Function:Tween(Utility["CopyButton"].Stroke, {Color = Settings.Themes[Settings.SelectedTheme].activeColor})
          wait(.5)
          Function:Tween(Utility["CopyButton"].Stroke, {Color = Settings.Themes[Settings.SelectedTheme].stroke})
        end
      end
    end)
    Utility["ClearButton"].InputBegan:Connect(function(input)
      if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        local Code = Utility["TextBox"]
        
        Code.Text = ""
        Function:Tween(Utility["ClearButton"].Stroke, {Color = Settings.Themes[Settings.SelectedTheme].activeColor})
        wait(.5)
        Function:Tween(Utility["ClearButton"].Stroke, {Color = Settings.Themes[Settings.SelectedTheme].stroke})
      end
    end)
  end
end

Library:MakeGUI()
