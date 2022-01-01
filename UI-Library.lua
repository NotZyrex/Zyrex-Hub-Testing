if not game:IsLoaded() then
	game.Loaded:Wait()
end

-- // --------- File System --------- // --
local FirstTime;

function DecodeJSON(JSON)
    return game:GetService("HttpService"):JSONDecode(JSON);
end;

function EncodeJSON(JSON)
    return game:GetService("HttpService"):JSONEncode(JSON);
end;

local LoadedSettings = {};

if not isfolder("./Zyrex-Hub") then
    makefolder("./Zyrex-Hub");
    makefolder("./Zyrex-Hub/Configs");
end

local FilePath = "./Zyrex-Hub/Configs/" .. tostring(game.PlaceId) .. ".json";
if not isfile(FilePath) then
    FirstTime = true;
    writefile(FilePath, "");

    FilePath = "./Zyrex-Hub/Configs/" .. tostring(game.PlaceId) .. ".json";
end;

local Status, Error = pcall(DecodeJSON, readfile(FilePath));
if not Status then
    if not FirstTime then
        warn("Unable to apphend file, resetting...")
    end;

    writefile(FilePath, "");
else
    local Decoded = DecodeJSON(readfile(FilePath));
    if Decoded then
        LoadedSettings = Decoded;
    end;
end;

-- // --------- Intro --------- // --

local IntroFinished;

function PlayIntro()

    local function CreateInstance(Class, Data)
        local Object = Instance.new(Class);
        for i,v in pairs(Data) do
            if i ~= "Parent" then
                if typeof(v) == "Instance" then
                    v.Parent = Object;
                else
                    Object[i] = v
                end
            end
        end

        Object.Parent = Data.Parent;

        return Object;
    end;

    local IntroGui = CreateInstance("ScreenGui", {
        Parent = game.CoreGui;
        ZIndexBehavior = Enum.ZIndexBehavior.Global;
        DisplayOrder = 1;
    });

    local Window = CreateInstance("Frame", {
        Name = "Window";
        Parent = IntroGui;
        AnchorPoint = Vector2.new(0.5, 0.5);
        BackgroundColor3 = Color3.fromRGB(255, 255, 255);
        BackgroundTransparency = 1.000;
        ClipsDescendants = true;
        BackgroundColor3 = Color3.fromRGB(26, 26, 26);
        Position = UDim2.new(0.5, 0, 0.49921751, 0);
        Size = UDim2.new(0, 480, 0, 258);
        ZIndex = 5;
    });

    local Circle = CreateInstance("ImageLabel", {
        Name = "Circle";
        Parent = Window;
        AnchorPoint = Vector2.new(0.5, 0.5);
        BackgroundColor3 = Color3.fromRGB(255, 255, 255);
        BackgroundTransparency = 1.000;
        ClipsDescendants = true;
        Position = UDim2.new(0.49975723, 0, 0.499271512, 0);
        Size = UDim2.new(0, 0, 0, 0);
        Image = "rbxassetid://3570695787";
        ImageColor3 = Color3.fromRGB(26, 26, 26);
        ScaleType = Enum.ScaleType.Slice;
        SliceCenter = Rect.new(100, 100, 100, 100);
        ZIndex = 5;
    });

    local Logo = CreateInstance("ImageLabel", {
        Name = "Logo";
        Parent = Circle;
        AnchorPoint = Vector2.new(0.5, 0.5);
        BackgroundColor3 = Color3.fromRGB(255, 255, 255);
        BackgroundTransparency = 1.000;
        Position = UDim2.new(0.5, 0, 0.5, 0);
        Size = UDim2.new(0, 100, 0, 100);
        Visible = true;
        Image = "rbxassetid://4977481293";
        ZIndex = 5;
        ImageTransparency = 1;
    });

    task.wait(1);

    Circle:TweenSize(UDim2.new(0, 100, 0, 100), "Out", "Quart", 1, true);

    task.wait(1);

    for i = 1, 10 do
        Logo.ImageTransparency = Logo.ImageTransparency - 0.1;
        task.wait(0.03);
    end;

    task.wait(0.4);
    
    Circle:TweenSize(UDim2.new(0, 600, 0, 600), "In", "Quart", 1, true);
    Logo:TweenSize(UDim2.new(0, 230, 0, 230), "In", "Quart", 1, true);

    task.wait(0.7);

    task.spawn(function()
        for i = 1, 10 do
            Logo.ImageTransparency = Logo.ImageTransparency + 0.1
            task.wait(0.03)
        end
    end)

    task.wait(0.2);

    IntroFinished = true;

    task.wait(0.5);

    task.spawn(function()
        for i = 1, 10 do
            Circle.ImageTransparency = Circle.ImageTransparency + 0.1
            task.wait(0.03)
        end
    end)

    task.wait(1);

    IntroGui:Destroy();
end

task.spawn(PlayIntro)

repeat task.wait() until IntroFinished

-- // --------- Library --------- // --

local Library = {Flags = {}, PageCount = 0, Pages = {}};
local States = {};

local UserInputService = game:GetService("UserInputService");
local TweenService = game:GetService("TweenService");
local Players = game:GetService("Players");
local LocalPlayer = Players.LocalPlayer;
local Mouse = LocalPlayer:GetMouse();

Library.ToggleKeybind = Library.ToggleKeybind or Enum.KeyCode.RightControl;

function Library:Create(Class, Data)
    local Object = Instance.new(Class);
    for i,v in pairs(Data) do
        if i ~= "Parent" then
            if typeof(v) == "Instance" then
                v.Parent = Object;
            else
                Object[i] = v
            end
        end
    end

    Object.Parent = Data.Parent;

    return Object;
end;

function Library:SaveSettings(Table)
    for i,v in pairs(Table) do
        if typeof(v) == "Color3" then
            local R, G, B = unpack(tostring(v):split(","));
            R = tonumber(R);
            G = tonumber(G);
            B = tonumber(B);
            if R and G and B then
                Table[i] = {
                    R = R * 255;
                    G = G * 255;
                    B = B * 255;
                }
            end;
        end;
        if typeof(v) == "EnumItem" then
            local Key = tostring(v):split(".")[3];
            Table[i] = Key;
        end
    end;
    writefile(FilePath, EncodeJSON(Table));
end;

function Library:Dropshadow(Frame, Data)
    Library:Create("Frame", {
        Name = "ShadowHolder";
        BackgroundTransparency = 1.000;
        Position = Data.HolderPosition;
        Size = Data.HolderSize;
        ZIndex = Data.ZIndex;
        Parent = Frame;
        Library:Create("ImageLabel", {
            AnchorPoint = Vector2.new(0.5, 0.5);
            BackgroundTransparency = 1.000;
            Position = Data.ShadowPosition;
            Size = Data.ShadowSize;
            ZIndex = Data.ZIndex;
            Image = "rbxassetid://1316045217";
            ImageColor3 = Color3.fromRGB(0, 0, 0);
            ImageTransparency = Data.Transparency;
            ScaleType = Enum.ScaleType.Slice;
            SliceCenter = Rect.new(10, 10, 118, 118);
        });
    });
end;

function Library:MakeDraggable(Object) 
    --// Original code by Tiffblocks, edited so that it has a cool tween to it. 
    local gui = Object
    
    local dragging
    local dragInput
    local dragStart
    local startPos
    
    local function update(input)
		local delta = input.Position - dragStart
		local EndPos = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        local Tween = TweenService:Create(
			gui, 
			TweenInfo.new(0.1), 
			{Position = EndPos}
		)
		Tween:Play()
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

function Library:RandomString(Length)
    local Stored = {}
    local Output = ""
    local Possible = "qwertyuiopasdfghjklzxcvbnmQWERTYUIOPASDFGHJKLZXCVBNM_-2345678901"
    Possible:gsub(".", function(Character)
        table.insert(Stored, Character)
    end)

    for i = 1, Length do
        Output = Output .. Stored[math.random(1, #Stored)]
    end

    return Output;
end

function Library:Tween(Object, Time, Data)
    TweenService:Create(Object, TweenInfo.new(
        Time,
        Enum.EasingStyle.Quad,
        Enum.EasingDirection.Out
    ), Data):Play()
end;

function Library:GetColor(Percentage, Keypoints)
    local Left = Keypoints[1]
	local Right = Keypoints[#Keypoints]
	local LocalPercentage = 0.5
	local Color = Left.Value
	
	for i = 1, #Keypoints-1 do
		if Keypoints[i].Time <= Percentage and Keypoints[i + 1].Time >= Percentage then
			Left = Keypoints[i]
			Right = Keypoints[i + 1]
			LocalPercentage = (Percentage - Left.Time) / (Right.Time - Left.Time)
			Color = Left.Value:lerp(Right.Value, LocalPercentage)
			return Color
		end
	end
end;

function Library:ClickEffect(obj)
    local Mouse = LocalPlayer:GetMouse()
	local Circle = Instance.new("ImageLabel")
	Circle.Name = "Circle"
	Circle.Parent = obj
	Circle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	Circle.BackgroundTransparency = 1.000
	Circle.ZIndex = 10
	Circle.Image = "rbxassetid://266543268"
	Circle.ImageColor3 = Color3.fromRGB(0, 0, 0)
	Circle.ImageTransparency = 0.4
	local NewX, NewY = Mouse.X - Circle.AbsolutePosition.X, Mouse.Y - Circle.AbsolutePosition.Y
	Circle.Position = UDim2.new(0, NewX, 0, NewY)
	local Size = 0
	if obj.AbsoluteSize.X > obj.AbsoluteSize.Y then
		Size = obj.AbsoluteSize.X * 1.5
	elseif obj.AbsoluteSize.X < obj.AbsoluteSize.Y then
		Size = obj.AbsoluteSize.Y * 1.5
	elseif obj.AbsoluteSize.X == obj.AbsoluteSize.Y then
		Size = obj.AbsoluteSize.X * 1.5
	end
	Circle:TweenSizeAndPosition(UDim2.new(0, Size, 0, Size), UDim2.new(0.5, - Size / 2, 0.5, - Size / 2), "Out", "Quad", 0.5, false)
	for i = 1, 20 do
		Circle.ImageTransparency = Circle.ImageTransparency + 0.05
		wait(0.3 / 10)
	end
	Circle:Destroy()
end;

--// Create Window:
function Library:CreateWindow(Data)
    local Window = {};
    Library.Window = Library:Create("ScreenGui", {
        Name = Library:RandomString(50);
        Parent = game.CoreGui;
        Library:Create("Frame", {
            Name = "MainFrame";
            AnchorPoint = Vector2.new(0.5, 0.5);
            BackgroundColor3 = Color3.fromRGB(26, 26, 26);
            Position = UDim2.new(0.5, 0, 0.49921751, 0);
            Size = UDim2.new(0, 480, 0, 258);
            Library:Create("UICorner", {
                CornerRadius = UDim.new(0, 4);
            });
            Library:Create("ImageLabel", {
                Name = "SmallLogo";
                BackgroundColor3 = Color3.fromRGB(255, 255, 255);
                BackgroundTransparency = 1.000;
                Position = UDim2.new(0, 0, -0.0232558139, 0);
                Size = UDim2.new(0, 54, 0, 54);
                Image = "rbxassetid://4977481293";
            });
            Library:Create("Frame", {
                Name = "SectionList";
                BackgroundColor3 = Color3.fromRGB(39, 39, 39);
                Position = UDim2.new(0.020833334, 0, 0.166666672, 0);
                Size = UDim2.new(0, 122, 0, 203);
                Library:Create("UICorner", {
                    CornerRadius = UDim.new(0, 4);
                });
                Library:Create("ScrollingFrame", {
                    Active = true;
                    BackgroundColor3 = Color3.fromRGB(255, 255, 255);
                    BackgroundTransparency = 1.000;
                    BorderSizePixel = 0;
                    Position = UDim2.new(0, 0, 0.024630541, 0);
                    Size = UDim2.new(0, 122, 0, 198);
                    ScrollBarThickness = 1;
                    Library:Create("UIListLayout", {
                        HorizontalAlignment = Enum.HorizontalAlignment.Center;
                        SortOrder = Enum.SortOrder.LayoutOrder;
                        Padding = UDim.new(0, 10);
                    })
                });
            });
            Library:Create("Frame", {
                Name = "Page";
                BackgroundColor3 = Color3.fromRGB(39, 39, 39);
                Position = UDim2.new(0.293749988, 0, 0.166666672, 0);
                Size = UDim2.new(0, 331, 0, 203);
                Library:Create("UICorner", {
                    CornerRadius = UDim.new(0, 4);
                });
            });
            Library:Create("ImageLabel", {
                BackgroundTransparency = 1.000;
                BorderSizePixel = 0;
                Position = UDim2.new(0.935416698, 0, 0.0348837227, 0);
                Size = UDim2.new(0, 23, 0, 23);
                ZIndex = 2;
                Image = "http://www.roblox.com/asset/?id=6031094678";
            });
            Library:Create("ImageLabel", {
                BackgroundTransparency = 1.000;
                BorderSizePixel = 0;
                Position = UDim2.new(0.854416668, 0, -0.00800000038, 5);
                Size = UDim2.new(0, 23, 0, 23);
                ZIndex = 2;
                Image = "http://www.roblox.com/asset/?id=6026568240";
            });
            Library:Create("TextButton", {
                Name = "Exit";
                AutoButtonColor = false;
                BackgroundColor3 = Color3.fromRGB(26, 26, 26);
                BorderSizePixel = 0;
                Position = UDim2.new(0.918749988, 0, 0, 0);
                Size = UDim2.new(0, 39, 0, 43);
                Font = Enum.Font.SourceSans;
                Text = "";
                TextColor3 = Color3.fromRGB(0, 0, 0);
                TextSize = 14.000;
                Library:Create("UICorner", {
                    CornerRadius = UDim.new(0, 3);
                });
            });
            Library:Create("TextButton", {
                Name = "Minimize";
                AutoButtonColor = false;
                BackgroundColor3 = Color3.fromRGB(26, 26, 26);
                BorderSizePixel = 0;
                Position = UDim2.new(0.837499976, 0, 0, 0);
                Size = UDim2.new(0, 39, 0, 43);
                Font = Enum.Font.SourceSans;
                Text = "";
                TextColor3 = Color3.fromRGB(0, 0, 0);
                TextSize = 14.000;
                Library:Create("UICorner", {
                    CornerRadius = UDim.new(0, 3);
                });
            });
            Library:Create("TextLabel", {
                Name = "Title";
                BackgroundColor3 = Color3.fromRGB(255, 255, 255);
                BackgroundTransparency = 1.000;
                Position = UDim2.new(0.112499997, 0, 0, 0);
                Size = UDim2.new(0, 426, 0, 43);
                Font = Enum.Font.Gotham;
                Text = Data.Title .. " | discord.gg/EAEtf82KuJ";
                TextColor3 = Color3.fromRGB(255, 255, 255);
                TextSize = 14.000;
                TextXAlignment = Enum.TextXAlignment.Left;
            })
        });
    });
    Library:Dropshadow(Library.Window.MainFrame, {
        HolderPosition = UDim2.new(-0.013, 0, -0.023, 0);
        HolderSize = UDim2.new(1.027, 0, 1.047, 0);
        ShadowPosition = UDim2.new(0.5, 0, 0.5, 2);
        ShadowSize = UDim2.new(1, 4, 1, 4);
        ZIndex = 0;
        Transparency = 0.860;
    });
    Library:MakeDraggable(Library.Window.MainFrame)

    function Window:SwitchPage(Name)
        local PageToSwitch = Library.Pages[Name];
        local CurrentPage = Library.CurrentPage;
        if PageToSwitch ~= CurrentPage then
            Library:Tween(PageToSwitch.Button, 0.2, {
                BackgroundColor3 = Color3.fromRGB(26, 26, 26);
            })
            Library:Tween(CurrentPage.Button, 0.2, {
                BackgroundColor3 = Color3.fromRGB(54, 54, 54);
            })
            PageToSwitch.Page.Size = UDim2.new(0, 331, 0, 0)
            CurrentPage.Page:TweenSize(UDim2.new(0, 331, 0, 0), "Out", "Quad", 0.3, true);
            task.wait(0.3)
            CurrentPage.Page.Visible = false
            task.wait(0.1)
            PageToSwitch.Page.Visible = true
            PageToSwitch.Page:TweenSize(UDim2.new(0, 331, 0, 182), "Out", "Quad", 0.3, true);
            Library.CurrentPage = PageToSwitch;
            task.wait(0.3)
            for i,v in pairs(Library.Pages) do
                if v.Page ~= Library.CurrentPage.Page then
                    v.Page.Visible = false;
                    v.Button.BackgroundColor3 = Color3.fromRGB(54, 54, 54);
                end;
            end;
        end;
    end;

    --// Page:
    function Window:Page(Data)
        local Page = {};
        Library.PageCount = Library.PageCount + 1;
        local ButtonColor = Color3.fromRGB(26, 26, 26);
        local FirstPage = true;
        if Library.PageCount > 1 then
            FirstPage = false;
            ButtonColor = Color3.fromRGB(54, 54, 54);
        end
        local PageButton = Library:Create("TextButton", {
            BackgroundColor3 = ButtonColor;
            BorderSizePixel = 0;
            Position = UDim2.new(0.0409836061, 0, 0, 0);
            Size = UDim2.new(0, 112, 0, 22);
            ZIndex = 3;
            AutoButtonColor = false;
            Font = Enum.Font.Gotham;
            Text = Data.Text;
            TextColor3 = Color3.fromRGB(255, 255, 255);
            TextSize = 14.000;
            Parent = Library.Window.MainFrame.SectionList.ScrollingFrame;
            Library:Create("UICorner", {
                CornerRadius = UDim.new(0, 3);
            });
        })

        Library.Pages[Data.Text] = {
            Page = Library:Create("ScrollingFrame", {
                Parent = Library.Window.MainFrame.Page;
                Active = true;
                BackgroundColor3 = Color3.fromRGB(255, 255, 255);
                BackgroundTransparency = 1.000;
                BorderSizePixel = 0;
                Position = UDim2.new(0, 0, 0.0541871935, 0);
                Size = UDim2.new(0, 331, 0, 182);
                CanvasPosition = Vector2.new(0, 375);
                CanvasSize = UDim2.new(0, 0, 5, 0);
                ScrollBarThickness = 1;
                Visible = FirstPage;
                Library:Create("UIListLayout", {
                    HorizontalAlignment = Enum.HorizontalAlignment.Center;
                    SortOrder = Enum.SortOrder.LayoutOrder;
                    Padding = UDim.new(0, 10);
                });
            });
            Button = PageButton;
        }

        local SelectedPage = Library.Pages[Data.Text];

        SelectedPage.Page.UIListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            SelectedPage.Page.CanvasSize = UDim2.new(0, 0, 0, SelectedPage.Page.UIListLayout.AbsoluteContentSize.Y)
        end)

        if FirstPage then
            Library.CurrentPage = SelectedPage;
        end;
        Library:Dropshadow(PageButton, {
            HolderPosition = UDim2.new(-0.013, 0, -0.187, 0);
            HolderSize = UDim2.new(1.027, 0, 1.437, 0);
            ShadowPosition = UDim2.new(0.5, 0, 0.462, 2);
            ShadowSize = UDim2.new(1, 4, 0.925, 4);
            Transparency = 0.860;
            ZIndex = 2;
        })
        PageButton.MouseButton1Down:Connect(function()
            Window:SwitchPage(PageButton.Text);
        end);

        --// Section:
        function Page:Section(Data)
            local Section = {};
            local SectionObject = Library:Create("Frame", {
                Parent = SelectedPage.Page;
                BackgroundColor3 = Color3.fromRGB(26, 26, 26);
                BorderSizePixel = 0;
                Position = UDim2.new(0.0271903332, 0, 0, 0);
                Size = UDim2.new(0, 317, 0, 32);
                ZIndex = 3;
                Library:Create("UICorner", {
                    CornerRadius = UDim.new(0, 4);
                });
                Library:Create("TextLabel", {
                    BackgroundColor3 = Color3.fromRGB(255, 255, 255);
                    BackgroundTransparency = 1.000;
                    Selectable = true;
                    Size = UDim2.new(1, 0, 1, 0);
                    ZIndex = 3;
                    Font = Enum.Font.Gotham;
                    Text = Data.Title;
                    TextColor3 = Color3.fromRGB(255, 255, 255);
                    TextSize = 14.000;
                });
            });

            Library:Dropshadow(SectionObject, {
                HolderPosition = UDim2.new(-0.013, 0, -0.187, 0);
                HolderSize = UDim2.new(1.027, 0, 1.437, 0);
                ShadowPosition = UDim2.new(0.5, 0, 0.462, 2);
                ShadowSize = UDim2.new(1, 4, 0.925, 4);
                Transparency = 0.860;
                ZIndex = 2;
            })

            --// Button:
            function Section:Button(Data)
                local Button = {};
                local ButtonObject = Library:Create("TextButton", {
                    Parent = SelectedPage.Page;
                    BackgroundColor3 = Color3.fromRGB(54, 54, 54);
                    BorderSizePixel = 0;
                    Position = UDim2.new(0.0223642178, 0, 0, 0);
                    Size = UDim2.new(0, 317, 0, 32);
                    ZIndex = 3;
                    AutoButtonColor = false;
                    Font = Enum.Font.Gotham;
                    TextColor3 = Color3.fromRGB(255, 255, 255);
                    TextSize = 14.000;
                    Text = Data.Text;
                    Library:Create("UICorner", {
                        CornerRadius = UDim.new(0, 3);
                    });
                    Library:Create("Frame", {
                        Name = "RippleEffectHolder";
                        BackgroundColor3 = Color3.fromRGB(255, 255, 255);
                        BackgroundTransparency = 1.000;
                        ClipsDescendants = true;
                        Size = UDim2.new(1, 0, 1, 0);
                        ZIndex = 2;
                    });
                });
                Library:Dropshadow(ButtonObject, {
                    HolderPosition = UDim2.new(-0.013, 0, -0.187, 0);
                    HolderSize = UDim2.new(1.027, 0, 1.437, 0);
                    ShadowPosition = UDim2.new(0.5, 0, 0.462, 2);
                    ShadowSize = UDim2.new(1, 4, 0.925, 4);
                    Transparency = 0.860;
                    ZIndex = 2;
                });

                function Button:Update(NewData)
                    ButtonObject.Text = NewData.Text;
                    if NewData.Callback then
                        Data.Callback = NewData.Callback;
                    end
                end;

                ButtonObject.MouseButton1Click:Connect(function()
                    task.spawn(function()
                        Library:ClickEffect(ButtonObject.RippleEffectHolder)
                    end);
                    pcall(Data.Callback)
                end);
            end;

            --// Toggle:
            function Section:Toggle(Data)
                local Toggle = {};

                Data.State = LoadedSettings[Data.Flag] or Data.State;

                Library.Flags[Data.Flag] = Data.State;

                local ToggleObject = Library:Create("TextButton", {
                    Parent = SelectedPage.Page;
                    BackgroundColor3 = Color3.fromRGB(54, 54, 54);
                    BorderSizePixel = 0;
                    Position = UDim2.new(0.0223642178, 0, 0, 0);
                    Size = UDim2.new(0, 317, 0, 32);
                    ZIndex = 3;
                    AutoButtonColor = false;
                    Font = Enum.Font.Gotham;
                    Text = "";
                    TextColor3 = Color3.fromRGB(255, 255, 255);
                    TextSize = 14.000;
                    Library:Create("UICorner", {
                        CornerRadius = UDim.new(0, 3);
                    });
                    Library:Create("Frame", {
                        Name = "RippleEffectHolder";
                        BackgroundColor3 = Color3.fromRGB(255, 255, 255);
                        BackgroundTransparency = 1.000;
                        ClipsDescendants = true;
                        Size = UDim2.new(1, 0, 1, 0);
                        ZIndex = 2;
                    });
                    Library:Create("TextLabel", {
                        BackgroundColor3 = Color3.fromRGB(255, 255, 255);
                        BackgroundTransparency = 1.000;
                        Position = UDim2.new(0.0347003154, 0, 0, 0);
                        Size = UDim2.new(0.766561508, 0, 1, 0);
                        ZIndex = 3;
                        Font = Enum.Font.Gotham;
                        Text = Data.Text;
                        TextColor3 = Color3.fromRGB(255, 255, 255);
                        TextSize = 14.000;
                        TextXAlignment = Enum.TextXAlignment.Left;
                    });
                    Library:Create("Frame", {
                        Name = "ToggleBackFrame";
                        BackgroundColor3 = Color3.fromRGB(26, 26, 26);
                        BorderSizePixel = 0;
                        Position = UDim2.new(0.851734996, 0, 0.34375, 0);
                        Size = UDim2.new(0, 39, 0, 10);
                        ZIndex = 3;
                        Library:Create("UICorner", {
                            CornerRadius = UDim.new(0, 8);
                        });
                        Library:Create("Frame", {
                            Name = "ToggleSlider";
                            BackgroundColor3 = Color3.fromRGB(255, 255, 255);
                            BorderSizePixel = 0;
                            Position = UDim2.new(-0.0199999996, 0, -0.25, 0);
                            Size = UDim2.new(0, 23, 0, 15);
                            ZIndex = 3;
                            Library:Create("UICorner", {
                                CornerRadius = UDim.new(1, 0);
                            });
                        });
                    });
                });

                Library:Dropshadow(ToggleObject, {
                    HolderPosition = UDim2.new(-0.013, 0, -0.187, 0);
                    HolderSize = UDim2.new(1.027, 0, 1.437, 0);
                    ShadowPosition = UDim2.new(0.5, 0, 0.462, 2);
                    ShadowSize = UDim2.new(1, 4, 0.925, 4);
                    Transparency = 0.860;
                    ZIndex = 2;
                });

                function Toggle:Update(NewData)
                    ToggleObject.TextLabel.Text = NewData.Text;
                    Library.Flags[Data.Flag] = NewData.State
                    if NewData.Callback then
                        Data.Callback = NewData.Callback;
                    end;
                    if NewData.State then
                        Library:Tween(ToggleObject.ToggleBackFrame, 0.3, {
                            BackgroundColor3 = Color3.fromRGB(56, 255, 42)
                        });
                        ToggleObject.ToggleBackFrame.ToggleSlider:TweenPosition(UDim2.new(0.4, 0, -0.25, 0), "Out", "Quad", 0.5, true);
                    else
                        Library:Tween(ToggleObject.ToggleBackFrame, 0.3, {
                            BackgroundColor3 = Color3.fromRGB(26, 26, 26)
                        });
                        ToggleObject.ToggleBackFrame.ToggleSlider:TweenPosition(UDim2.new(-0.02, 0, -0.25, 0), "Out", "Quad", 0.5, true);
                    end
                end;

                ToggleObject.MouseButton1Click:Connect(function()
                    task.spawn(function()
                        Library:ClickEffect(ToggleObject.RippleEffectHolder)
                    end);
                    Library.Flags[Data.Flag] = not Library.Flags[Data.Flag]
                    Toggle:Update({
                        Text = Data.Text;
                        Callback = nil;
                        State = Library.Flags[Data.Flag]
                    })
                    pcall(Data.Callback, Library.Flags[Data.Flag]);
                end);

                Toggle:Update({
                    Text = Data.Text;
                    Callback = nil;
                    State = Data.State;
                })

                if LoadedSettings[Data.Flag] then
                    pcall(Data.Callback, LoadedSettings[Data.Flag]);
                end

                return Toggle;
            end;

            --// Box
            function Section:Box(Data)
                Data.Value = LoadedSettings[Data.Flag] or Data.Value;
                Library.Flags[Data.Flag] = Data.Value;

                local BoxObject = Library:Create("TextButton", {
                    Parent = SelectedPage.Page;
                    BackgroundColor3 = Color3.fromRGB(54, 54, 54);
                    BorderSizePixel = 0;
                    Position = UDim2.new(0.0223642178, 0, 0, 0);
                    Size = UDim2.new(0, 317, 0, 32);
                    ZIndex = 3;
                    AutoButtonColor = false;
                    Font = Enum.Font.Gotham;
                    Text = "";
                    TextColor3 = Color3.fromRGB(255, 255, 255);
                    TextSize = 14.000;
                    Library:Create("UICorner", {
                        CornerRadius = UDim.new(0, 3);
                    });
                    Library:Create("TextLabel", {
                        BackgroundColor3 = Color3.fromRGB(255, 255, 255);
                        BackgroundTransparency = 1.000;
                        Position = UDim2.new(0.0347003154, 0, 0, 0);
                        Size = UDim2.new(0.766561508, 0, 1, 0);
                        ZIndex = 3;
                        Font = Enum.Font.Gotham;
                        Text = Data.Text;
                        TextColor3 = Color3.fromRGB(255, 255, 255);
                        TextSize = 14.000;
                        TextXAlignment = Enum.TextXAlignment.Left;
                    });
                });

                local InputObject = Library:Create("TextBox", {
                    Parent = BoxObject;
                    BackgroundColor3 = Color3.fromRGB(26, 26, 26);
                    BorderSizePixel = 0;
                    Position = UDim2.new(0.495268136, 0, 0.21875, 0);
                    Size = UDim2.new(0, 152, 0, 18);
                    ZIndex = 3;
                    Font = Enum.Font.Gotham;
                    Text = Data.Value;
                    TextColor3 = Color3.fromRGB(255, 255, 255);
                    TextSize = 14.000;
                    Library:Create("UICorner", {
                        CornerRadius = UDim.new(0, 3);
                    });
                });

                InputObject.FocusLost:Connect(function(enterPressed)
                    if not enterPressed then return end;
                    local NewValue = InputObject.Text;
                    Library.Flags[Data.Flag] = NewValue;
                    pcall(Data.Callback, NewValue);
                end);

                Library:Dropshadow(BoxObject, {
                    HolderPosition = UDim2.new(-0.013, 0, -0.187, 0);
                    HolderSize = UDim2.new(1.027, 0, 1.437, 0);
                    ShadowPosition = UDim2.new(0.5, 0, 0.462, 2);
                    ShadowSize = UDim2.new(1, 4, 0.925, 4);
                    Transparency = 0.860;
                    ZIndex = 2;
                });

                if LoadedSettings[Data.Flag] then
                    pcall(Data.Callback, LoadedSettings[Data.Flag]);
                end
            end;

            --// Slider
            function Section:Slider(Data)
                local ButtonDown = false;
                local Slider = {};

                Data.Value = LoadedSettings[Data.Flag] or Data.Value;

                Library.Flags[Data.Flag] = Data.Value;

                local SliderObject = Library:Create("Frame", {
                    Parent = SelectedPage.Page;
                    BackgroundColor3 = Color3.fromRGB(54, 54, 54);
                    BorderSizePixel = 0;
                    Position = UDim2.new(0.0211480372, 0, 0.0989011005, 0);
                    Size = UDim2.new(0, 317, 0, 62);
                    ZIndex = 3;
                    Library:Create("UICorner", {
                        CornerRadius = UDim.new(0, 3);
                    });
                    Library:Create("TextLabel", {
                        BackgroundColor3 = Color3.fromRGB(255, 255, 255);
                        BackgroundTransparency = 1.000;
                        Position = UDim2.new(0.035, 0, 0.111, 0);
                        Selectable = true;
                        Size = UDim2.new(0.461, 0, 0.358, 0);
                        ZIndex = 3;
                        Font = Enum.Font.Gotham;
                        Text = Data.Text;
                        TextColor3 = Color3.fromRGB(255, 255, 255);
                        TextSize = 14.000;
                        TextXAlignment = Enum.TextXAlignment.Left;
                    });
                    Library:Create("TextButton", {
                        Name = "SliderBack",
                        BackgroundColor3 = Color3.fromRGB(26, 26, 26);
                        BorderSizePixel = 0;
                        Position = UDim2.new(0.030, 0, 0.64, 0);
                        Size = UDim2.new(0, 298, 0, 6);
                        ZIndex = 3;
                        AutoButtonColor = false;
                        Font = Enum.Font.SourceSans;
                        Text = "";
                        TextColor3 = Color3.fromRGB(0, 0, 0);
                        TextSize = 14.000;
                        Library:Create("UICorner", {
                            CornerRadius = UDim.new(0, 3);
                        });
                    });
                    Library:Create("TextLabel", {
                        Name = "Value";
                        BackgroundColor3 = Color3.fromRGB(255, 255, 255);
                        BackgroundTransparency = 1.000;
                        Position = UDim2.new(0.495, 0, 0.111, 0);
                        Selectable = true;
                        Size = UDim2.new(0.479, 0, 0.358, 0);
                        ZIndex = 3;
                        Font = Enum.Font.Gotham;
                        Text = Data.Value;
                        TextColor3 = Color3.fromRGB(255, 255, 255);
                        TextSize = 14.000;
                        TextXAlignment = Enum.TextXAlignment.Right;
                    })
                });
                local SliderHandle = Library:Create("TextButton", {
                    Parent = SliderObject.SliderBack;
                    AnchorPoint = Vector2.new(0.5, 0.349999994);
                    BackgroundColor3 = Color3.fromRGB(255, 255, 255);
                    BorderSizePixel = 0;
                    Position = UDim2.new(0.0939999968, 0, 0, 0);
                    Size = UDim2.new(0, 7, 0, 20);
                    ZIndex = 3;
                    AutoButtonColor = false;
                    Font = Enum.Font.SourceSans;
                    Text = "";
                    TextColor3 = Color3.fromRGB(0, 0, 0);
                    TextSize = 14.000;
                    Library:Create("UICorner", {
                        CornerRadius = UDim.new(0, 3);
                    });
                });
                Library:Dropshadow(SliderObject, {
                    HolderPosition = UDim2.new(-0.013, 0, -0.05, 0);
                    HolderSize = UDim2.new(1.027, 0, 1.177, 0);
                    ShadowPosition = UDim2.new(0.5, 0, 0.462, 2);
                    ShadowSize = UDim2.new(1, 4, 0.945, 4);
                    Transparency = 0.860;
                    ZIndex = 2;
                });

                function Slider:Update(NewData)
                    SliderObject.TextLabel.Text = NewData.Text;
                    if NewData.Callback then
                        Data.Callback = NewData.Callback;
                    end;

                    local Bar = SliderObject.SliderBack

                    local Min, Max = NewData.Min, NewData.Max;

                    local Range = (Mouse.X - Bar.AbsolutePosition.X) / Bar.AbsoluteSize.X

                    local Value = NewData.Value

                    if Value then
                        Range = (Value - Min) / (Max - Min)
                    end
                    local Percent = math.clamp(Range, 0, 1)
                    if NewData.Float then
                        Value = Value or math.floor((Min + (Max - Min) * Percent) / NewData.Float) * NewData.Float
                    else
                        Value = Value or math.floor(Min + (Max - Min) * Percent)
                    end

                    SliderObject.Value.Text = Value
                    Library.Flags[Data.Flag] = Value
                    
                    Library:Tween(SliderHandle, 0.1, {
                        Position = UDim2.new(Percent, 0, 0, 0)
                    });
                end;

                UserInputService.InputEnded:Connect(function(Input)
                    if Input.UserInputType == Enum.UserInputType.MouseButton1 then
                        ButtonDown = false;
                    end
                end);

                Slider:Update({
                    Text = Data.Text;
                    Callback = nil;
                    Value = Data.Value;
                    Min = Data.Min;
                    Max = Data.Max;
                    Float = Data.Float;
                });

                SliderHandle.MouseButton1Down:Connect(function()
                    ButtonDown = true;
                    while ButtonDown do
                        Slider:Update({
                            Text = Data.Text;
                            Callback = nil;
                            Value = nil;
                            Min = Data.Min;
                            Max = Data.Max;
                            Float = Data.Float;
                        });
                        pcall(Data.Callback, Library.Flags[Data.Flag])
                        task.wait();
                    end
                end);

                if LoadedSettings[Data.Flag] then
                    pcall(Data.Callback, LoadedSettings[Data.Flag]);
                end

                return Slider;
            end;

            --// Dropdown
            function Section:Dropdown(Data)
                local Dropdown = {};
                local DropdownToggled = false;

                Data.Value = LoadedSettings[Data.Flag] or Data.Value;

                Library.Flags[Data.Flag] = Data.Value;
                local DropdownObject = Library:Create("TextButton", {
                    Parent = SelectedPage.Page;
                    BackgroundColor3 = Color3.fromRGB(54, 54, 54);
                    BorderSizePixel = 0;
                    Position = UDim2.new(0.0223642178, 0, 0, 0);
                    Size = UDim2.new(0, 317, 0, 32);
                    ZIndex = 3;
                    AutoButtonColor = false;
                    Font = Enum.Font.Gotham;
                    Text = Data.Text;
                    TextColor3 = Color3.fromRGB(255, 255, 255);
                    TextSize = 14.000;
                    Library:Create("UICorner", {
                        CornerRadius = UDim.new(0, 3);
                    });
                    Library:Create("Frame", {
                        Name = "DropdownFrame";
                        BackgroundColor3 = Color3.fromRGB(54, 54, 54);
                        BorderSizePixel = 0;
                        ClipsDescendants = true;
                        Position = UDim2.new(0, 0, 1.15625, 0);
                        Size = UDim2.new(0, 317, 0, 0);
                        Visible = false;
                        ZIndex = 4;
                        Library:Create("UICorner", {
                            CornerRadius = UDim.new(0, 3);
                        });
                    });
                    Library:Create("Frame", {
                        Name = "RippleEffectHolder";
                        BackgroundColor3 = Color3.fromRGB(255, 255, 255);
                        BackgroundTransparency = 1.000;
                        ClipsDescendants = true;
                        Size = UDim2.new(1, 0, 1, 0);
                        ZIndex = 2;
                    });
                    Library:Create("ImageLabel", {
                        BackgroundTransparency = 1.000;
                        BorderSizePixel = 0;
                        Position = UDim2.new(0.899432182, 0, 0.0625, 0);
                        Rotation = 180.000;
                        Size = UDim2.new(0, 31, 0, 31);
                        ZIndex = 4;
                        Image = "http://www.roblox.com/asset/?id=6031091004";
                    });
                });

                local List = Library:Create("Folder", {
                    Parent = DropdownObject.DropdownFrame;
                    Library:Create("UIListLayout", {
                        HorizontalAlignment = Enum.HorizontalAlignment.Center;
                        SortOrder = Enum.SortOrder.LayoutOrder;
                    });
                });

                Library:Dropshadow(DropdownObject, {
                    HolderPosition = UDim2.new(-0.013, 0, -0.187, 0);
                    HolderSize = UDim2.new(1.027, 0, 1.437, 0);
                    ShadowPosition = UDim2.new(0.5, 0, 0.462, 2);
                    ShadowSize = UDim2.new(1, 4, 0.925, 4);
                    Transparency = 0.860;
                    ZIndex = 2;
                });

                Library:Dropshadow(DropdownObject.DropdownFrame, {
                    HolderPosition = UDim2.new(-0.013, 0, -0.187, 0);
                    HolderSize = UDim2.new(1.027, 0, 1.437, 0);
                    ShadowPosition = UDim2.new(0.5, 0, 0.462, 2);
                    ShadowSize = UDim2.new(1, 4, 0.925, 4);
                    Transparency = 0.860;
                    ZIndex = 3;
                });

                function Dropdown:Update(NewData)
                    DropdownObject.Text = NewData.Text;
                    if NewData.Callback then
                        Data.Callback = NewData.Callback;
                    end;
                    for i,v in pairs(List:GetChildren()) do
                        if not v:IsA("UIListLayout") then
                            v:Destroy();
                        end;
                    end;
                    for i,v in pairs(NewData.List) do
                        local Button = Library:Create("TextButton", {
                            Text = v;
                            Parent = List;
                            BackgroundColor3 = Color3.fromRGB(54, 54, 54);
                            BorderSizePixel = 0;
                            Size = UDim2.new(0, 317, 0, 32);
                            ZIndex = 4;
                            AutoButtonColor = false;
                            Font = Enum.Font.Gotham;
                            TextColor3 = Color3.fromRGB(255, 255, 255);
                            TextSize = 14.000;
                            ClipsDescendants = true;
                            Library:Create("UICorner", {
                                CornerRadius = UDim.new(0, 3);
                            });
                        });
                        Button.MouseButton1Click:Connect(function()
                            task.spawn(function()
                                Library:ClickEffect(Button);
                            end);
                            DropdownObject.Text = Button.Text;
                            Library.Flags[Data.Flag] = Button.Text;
                            pcall(Data.Callback, Library.Flags[Data.Flag]);
                        end);
                    end
                end;

                Dropdown:Update({
                    Text = Data.Text;
                    Callback = Data.Callback;
                    List = Data.List;
                })

                DropdownObject.MouseButton1Click:Connect(function()
                    DropdownToggled = not DropdownToggled;
                    task.spawn(function()
                        Library:ClickEffect(DropdownObject.RippleEffectHolder);
                    end);
                    if DropdownToggled then
                        Library:Tween(DropdownObject.ImageLabel, 0.1, {
                            Rotation = 0;
                        });
                        DropdownObject.DropdownFrame.Visible = true;
                        DropdownObject.DropdownFrame:TweenSize(UDim2.new(0, 317, 0, List.UIListLayout.AbsoluteContentSize.Y), "Out", "Quad", 0.3, true);
                        task.wait(0.3)
                        DropdownObject.DropdownFrame.ClipsDescendants = false;
                    else
                        DropdownObject.DropdownFrame.ClipsDescendants = true;
                        Library:Tween(DropdownObject.ImageLabel, 0.1, {
                            Rotation = 180;
                        });
                        DropdownObject.DropdownFrame:TweenSize(UDim2.new(0, 317, 0, 0), "Out", "Quad", 0.3, true);
                        task.wait(0.3)
                        DropdownObject.DropdownFrame.Visible = false;
                    end
                end);

                if LoadedSettings[Data.Flag] then
                    pcall(Data.Callback, LoadedSettings[Data.Flag]);
                end

                return Dropdown;
            end;

            --// Color Picker
            function Section:ColorPicker(Data)
                local ColorPicker = {};

                local RainbowSliderDown = false;
                local BrightnessSliderDown = false;
                local SetColor;
                if LoadedSettings[Data.Flag] then
                    SetColor = Color3.fromRGB(LoadedSettings[Data.Flag].R, LoadedSettings[Data.Flag].G, LoadedSettings[Data.Flag].B);
                end

                Data.Color = SetColor or Data.Color;

                Library.Flags[Data.Flag] = SetColor;

                local ColorPickerObject = Library:Create("TextButton", {
                    Parent = SelectedPage.Page;
                    BackgroundColor3 = Color3.fromRGB(54, 54, 54);
                    BorderSizePixel = 0;
                    Position = UDim2.new(0.0211480372, 0, 0.318681329, 0);
                    Size = UDim2.new(0, 317, 0, 101);
                    ZIndex = 3;
                    AutoButtonColor = false;
                    Font = Enum.Font.Gotham;
                    Text = "";
                    TextColor3 = Color3.fromRGB(255, 255, 255);
                    TextSize = 14.000;
                    Library:Create("UICorner", {
                        CornerRadius = UDim.new(0, 3);
                    });
                    Library:Create("Frame", {
                        Name = "OutputColor";
                        BackgroundColor3 = Data.Color;
                        BorderSizePixel = 0;
                        Position = UDim2.new(0.769716084, 0, 0.109595552, 0);
                        Size = UDim2.new(0, 65, 0, 18);
                        ZIndex = 3;
                        Library:Create("UICorner", {
                            CornerRadius = UDim.new(0, 3);
                        });
                    });
                    Library:Create("TextLabel", {
                        BackgroundColor3 = Color3.fromRGB(255, 255, 255);
                        BackgroundTransparency = 1.000;
                        Position = UDim2.new(0.0347003154, 0, 0.0679287314, 0);
                        Selectable = true;
                        Size = UDim2.new(0.460567832, 0, 0.221994549, 0);
                        ZIndex = 3;
                        Font = Enum.Font.Gotham;
                        Text = Data.Text;
                        TextColor3 = Color3.fromRGB(255, 255, 255);
                        TextSize = 14.000;
                        TextXAlignment = Enum.TextXAlignment.Left;
                    });
                    Library:Create("Frame", {
                        Name = "RainbowSlider";
                        BackgroundColor3 = Color3.fromRGB(255, 255, 255);
                        BorderSizePixel = 0;
                        Position = UDim2.new(0.0347003154, 0, 0.408891052, 0);
                        Size = UDim2.new(0, 298, 0, 18);
                        ZIndex = 3;
                        Library:Create("UICorner", {
                            CornerRadius = UDim.new(0, 3);
                        });
                        Library:Create("UIGradient", {
                            Color = ColorSequence.new{ColorSequenceKeypoint.new(0.00, Color3.fromRGB(255, 0, 4)), ColorSequenceKeypoint.new(0.20, Color3.fromRGB(255, 255, 0)), ColorSequenceKeypoint.new(0.40, Color3.fromRGB(0, 255, 0)), ColorSequenceKeypoint.new(0.60, Color3.fromRGB(0, 255, 255)), ColorSequenceKeypoint.new(0.80, Color3.fromRGB(0, 0, 255)), ColorSequenceKeypoint.new(1.00, Color3.fromRGB(255, 0, 255))};
                            Name = "Rainbow";
                        });
                    });
                    Library:Create("Frame", {
                        Name = "BrightnessSlider";
                        BackgroundColor3 = Color3.fromRGB(255, 255, 255);
                        BorderSizePixel = 0;
                        Position = UDim2.new(0.0347003154, 0, 0.707381606, 0);
                        Size = UDim2.new(0, 298, 0, 18);
                        ZIndex = 3;
                        Library:Create("UICorner", {
                            CornerRadius = UDim.new(0, 3);
                        });
                        Library:Create("UIGradient", {
                            Color = ColorSequence.new{ColorSequenceKeypoint.new(0.00, Color3.fromRGB(255, 255, 255)), ColorSequenceKeypoint.new(0.50, Color3.fromRGB(255, 0, 0)), ColorSequenceKeypoint.new(1.00, Color3.fromRGB(0, 0, 0))};
                        });
                    });
                });

                local RainbowSliderHandle = Library:Create("TextButton", {
                    Parent = ColorPickerObject.RainbowSlider;
                    AnchorPoint = Vector2.new(0.5, 0.150000006);
                    BackgroundColor3 = Color3.fromRGB(255, 255, 255);
                    BorderSizePixel = 0;
                    Position = UDim2.new(0.134000003, 0, 0, 0);
                    Size = UDim2.new(0, 7, 0, 24);
                    ZIndex = 3;
                    AutoButtonColor = false;
                    Font = Enum.Font.SourceSans;
                    Text = "";
                    TextColor3 = Color3.fromRGB(0, 0, 0);
                    TextSize = 14.000;
                    Library:Create("UICorner", {
                        CornerRadius = UDim.new(0, 3);
                    });
                });

                local BrightnessSliderHandle = Library:Create("TextButton", {
                    Parent = ColorPickerObject.BrightnessSlider;
                    AnchorPoint = Vector2.new(0.5, 0.150000006);
                    BackgroundColor3 = Color3.fromRGB(255, 255, 255);
                    BorderSizePixel = 0;
                    Position = UDim2.new(0.49000001, 0, 0, 0);
                    Size = UDim2.new(0, 7, 0, 24);
                    ZIndex = 3;
                    AutoButtonColor = false;
                    Font = Enum.Font.SourceSans;
                    Text = "";
                    TextColor3 = Color3.fromRGB(0, 0, 0);
                    TextSize = 14.000;
                    Library:Create("UICorner", {
                        CornerRadius = UDim.new(0, 3);
                    });
                });

                Library:Dropshadow(ColorPickerObject, {
                    HolderPosition = UDim2.new(-0.013, 0, -0.073, 0);
                    HolderSize = UDim2.new(1.027, 0, 1.177, 0);
                    ShadowPosition = UDim2.new(0.5, 0, 0.472, 2);
                    ShadowSize = UDim2.new(1, 4, 0.944, 4);
                    Transparency = 0.860;
                    ZIndex = 2;
                });

                function ColorPicker:UpdateColor()
                    local Bar = ColorPickerObject.RainbowSlider;
                    local Range = (Mouse.X - Bar.AbsolutePosition.X) / Bar.AbsoluteSize.X

                    local Percent = math.clamp(Range, 0, 1);

                    local ColorValue = Library:GetColor(Percent, Bar.Rainbow.Color.Keypoints);

                    local Color = ColorSequence.new({
                        ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
                        ColorSequenceKeypoint.new(0.5, ColorValue),
                        ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 0, 0))
                    });

                    ColorPickerObject.BrightnessSlider.UIGradient.Color = Color;

                    Library:Tween(RainbowSliderHandle, 0.1, {
                        Position = UDim2.new(Percent, 0, 0)
                    });
                end;

                function ColorPicker:Update(NewData)
                    local Bar = ColorPickerObject.BrightnessSlider;
                    ColorPickerObject.TextLabel.Text = NewData.Text;
                    local Range = (NewData.Location - Bar.AbsolutePosition.X) / Bar.AbsoluteSize.X

                    if NewData.Color then
                        local ColorSeq = ColorSequence.new({
                            ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
                            ColorSequenceKeypoint.new(0.5, NewData.Color),
                            ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 0, 0))
                        });

                        Bar.UIGradient.Color = ColorSeq;
                        Library.Flags[Data.Flag] = NewData.Color;
                        ColorPickerObject.OutputColor.BackgroundColor3 = NewData.Color;
                    else
                        local Range = (NewData.Location - Bar.AbsolutePosition.X) / Bar.AbsoluteSize.X
                        local Percent = math.clamp(Range, 0, 1);

                        local ColorValue = Library:GetColor(Percent, Bar.UIGradient.Color.Keypoints);

                        ColorPickerObject.OutputColor.BackgroundColor3 = ColorValue;

                        Library.Flags[Data.Flag] = ColorValue;

                        if NewData.Move then
                            Library:Tween(BrightnessSliderHandle, 0.1, {
                                Position = UDim2.new(Percent, 0, 0)
                            });
                        end;
                    end;

                    pcall(Data.Callback, Library.Flags[Data.Flag]);
                end;

                ColorPicker:Update({
                    Color = Data.Color;
                    Text = Data.Text;
                    Location = BrightnessSliderHandle.AbsolutePosition.X;
                })

                UserInputService.InputEnded:Connect(function(Input)
                    if Input.UserInputType == Enum.UserInputType.MouseButton1 then
                        RainbowSliderDown = false;
                        BrightnessSliderDown = false;
                    end
                end);

                RainbowSliderHandle.MouseButton1Down:Connect(function()
                    RainbowSliderDown = true;
                    while RainbowSliderDown do
                        ColorPicker:UpdateColor();
                        ColorPicker:Update({
                            Location = BrightnessSliderHandle.AbsolutePosition.X;
                            Text = Data.Text;
                        });
                        task.wait();
                    end
                end);

                BrightnessSliderHandle.MouseButton1Down:Connect(function()
                    BrightnessSliderDown = true;
                    while BrightnessSliderDown do
                        ColorPicker:Update({
                            Location = Mouse.X;
                            Text = Data.Text;
                            Move = true;
                        });
                        task.wait();
                    end
                end);

                if LoadedSettings[Data.Flag] and Data.Callback then
                    pcall(Data.Callback, Data.Color);
                end

                return ColorPicker;
            end;

            --// Label
            function Section:Label(Data)
                local Label = {};
                local LabelObject = Library:Create("TextLabel", {
                    Parent = SelectedPage.Page;
                    Text = Data.Text;
                    BackgroundColor3 = Color3.fromRGB(54, 54, 54);
                    BorderSizePixel = 0;
                    Position = UDim2.new(0.0271903332, 0, 0, 0);
                    Size = UDim2.new(0, 317, 0, 32);
                    ZIndex = 3;
                    Font = Enum.Font.Gotham;
                    TextColor3 = Color3.fromRGB(255, 255, 255);
                    TextSize = 14.000;
                    Library:Create("UICorner", {
                        CornerRadius = UDim.new(0, 3);
                    });
                });

                Library:Dropshadow(LabelObject, {
                    HolderPosition = UDim2.new(-0.013, 0, -0.187, 0);
                    HolderSize = UDim2.new(1.027, 0, 1.437, 0);
                    ShadowPosition = UDim2.new(0.5, 0, 0.462, 2);
                    ShadowSize = UDim2.new(1, 4, 0.925, 4);
                    Transparency = 0.860;
                    ZIndex = 2;
                });

                function Label:Update(NewData)
                    LabelObject.Text = NewData.Text;
                end;

                return Label;
            end;

            --// Keybind
            function Section:Keybind(Data)
                local Keybind = {}
                local SetKey;
                pcall(function()
                    SetKey = Enum.KeyCode[LoadedSettings[Data.Flag]];
                end);
                Data.Bind = SetKey or Data.Bind;
                Library.Flags[Data.Flag] = Data.Bind;
                local ConnectionActive = false;

                local KeybindObject = Library:Create("TextButton", {
                    Parent = SelectedPage.Page;
                    BackgroundColor3 = Color3.fromRGB(54, 54, 54);
                    BorderSizePixel = 0;
                    Position = UDim2.new(0.0223642178, 0, 0, 0);
                    Size = UDim2.new(0, 317, 0, 32);
                    ZIndex = 3;
                    AutoButtonColor = false;
                    Font = Enum.Font.Gotham;
                    Text = "";
                    TextColor3 = Color3.fromRGB(255, 255, 255);
                    TextSize = 14.000;
                    Library:Create("TextLabel", {
                        BackgroundColor3 = Color3.fromRGB(255, 255, 255);
                        BackgroundTransparency = 1.000;
                        Position = UDim2.new(0.0347003154, 0, 0, 0);
                        Size = UDim2.new(0.766561508, 0, 1, 0);
                        ZIndex = 3;
                        Font = Enum.Font.Gotham;
                        Text = Data.Text;
                        TextColor3 = Color3.fromRGB(255, 255, 255);
                        TextSize = 14.000;
                        TextXAlignment = Enum.TextXAlignment.Left;
                    });
                    Library:Create("UICorner", {
                        CornerRadius = UDim.new(0, 3);
                    });
                    Library:Create("TextButton", {
                        Name = "KeybindInput";
                        BackgroundColor3 = Color3.fromRGB(26, 26, 26);
                        BorderSizePixel = 0;
                        Position = UDim2.new(0.712933779, 0, 0.21875, 0);
                        Size = UDim2.new(0, 83, 0, 18);
                        ZIndex = 3;
                        AutoButtonColor = false;
                        Font = Enum.Font.Gotham;
                        Text = "None";
                        TextColor3 = Color3.fromRGB(255, 255, 255);
                        TextSize = 14.000;
                        Library:Create("UICorner", {
                            CornerRadius = UDim.new(0, 3);
                        });
                    });
                });

                Library:Dropshadow(KeybindObject, {
                    HolderPosition = UDim2.new(-0.013, 0, -0.187, 0);
                    HolderSize = UDim2.new(1.027, 0, 1.437, 0);
                    ShadowPosition = UDim2.new(0.5, 0, 0.462, 2);
                    ShadowSize = UDim2.new(1, 4, 0.925, 4);
                    Transparency = 0.860;
                    ZIndex = 2;
                });

                function Keybind:Update(NewData)
                    local Args = tostring(NewData.Bind):split(".");
                    local Key = Args[3];
                    Library.Flags[Data.Flag] = NewData.Bind;
                    KeybindObject.KeybindInput.Text = Key;
                    ConnectionActive = false;
                end;

                KeybindObject.KeybindInput.MouseButton1Click:Connect(function()
                    ConnectionActive = true;
                    KeybindObject.KeybindInput.Text = "...";
                end);

                UserInputService.InputBegan:Connect(function(Input, Processed)
                    if Processed then
                        return
                    end;
                    if Input.UserInputType == Enum.UserInputType.Keyboard and ConnectionActive then
                        Keybind:Update({
                            Bind = Input.KeyCode
                        });
                        pcall(Data.Callback, Input.KeyCode);
                    end;
                end);

                Keybind:Update({
                    Bind = Data.Bind;
                })

                if LoadedSettings[Data.Flag] and Data.Callback then
                    pcall(Data.Callback, SetKey);
                end

                return Keybind;
            end;

            return Section;
        end;

        return Page;
    end;
    return Window;
end

--// Minimize / Close
task.spawn(function()
    local InputConnection;

    repeat -- I'm Lazy
        task.wait()
    until Library.Window ~= nil;

    Library.Window.MainFrame.Minimize.MouseButton1Down:Connect(function()
        Library.Window.MainFrame.Visible = false;
    end)
    Library.Window.MainFrame.Exit.MouseButton1Down:Connect(function()
        Library.Window.MainFrame:Destroy();
        InputConnection:Disconnect();
    end)

    InputConnection = UserInputService.InputBegan:Connect(function(Input)
        if Input.UserInputType == Enum.UserInputType.Keyboard and Input.KeyCode == Library.ToggleKeybind then
            Library.Window.MainFrame.Visible = not Library.Window.MainFrame.Visible;
        end;
    end);
end);

return Library;
