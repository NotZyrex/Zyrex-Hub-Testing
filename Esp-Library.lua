local Esp = {
    Teamcheck = false, 
    TeamColor = false,
    Overrides = {
        RootPartName = "HumanoidRootPart", 
        HeadName = "Head"
    }, 
    Config = {
        Color = Color3.fromRGB(255, 255, 255);
        Enabled = false;
        Tracers = false;
        FOVCircleColor = Color3.fromRGB(255, 255, 255);
        FOVRadius = 200;
    }
};
local Data = {};
Esp.Objects = {};

local Services = setmetatable({}, {
    __index = function(Table, Index)
        return game.GetService(game, Index);
    end;
});

local Camera = Services.Workspace.CurrentCamera;

function Esp:GetPlayers()
    if Esp.Overrides.GetPlayers then
        return Esp.Overrides.GetPlayers();
    end;

    return Services.Players.GetPlayers(Services.Players);
end

function Esp:GetCharacter(Player)
    if Esp.Overrides.GetCharacter then
        return Esp.Overrides.GetCharacter(Player);
    end;

    return Player.Character;
end;

function Esp:GetLocalPlayer()
    if Esp.Overrides.GetLocalPlayer then
        return Esp.Overrides.GetLocalPlayer();
    end;

    return Services.Players.LocalPlayer;
end;

function Esp:GetMouse()
    if Esp.Overrides.GetMouse then
        return Esp.Overrides.GetMouse();
    end;

    return Esp:GetLocalPlayer().GetMouse(Esp:GetLocalPlayer());
end;

function Esp:GetTeam(Player)
    if Esp.Overrides.GetTeam then
        return Esp.Overrides.GetTeam(Player);
    end;

    return Player.Team;
end;

function Esp:GetTeamColor(Player)
    if Esp.Overrides.GetTeamColor then
        return Esp.Overrides.GetTeamColor(Player);
    end;

    return Esp.TeamColor and Player.Team and Player.TeamColor.Color or Esp.Config.Color;
end;

function Esp:GetPlayerFromCharacter(Model)
    if Esp.Overrides.GetPlayerFromCharacter then
        return Esp.Overrides.GetPlayerFromCharacter(Model);
    end
    
    return Services.Players.GetPlayerFromCharacter(Services.Players, Model);
end;

function Esp:Create(Type, Data)
    local DrawingObject = Drawing.new(Type);
    for i,v in pairs(Data) do
        DrawingObject[i] = v;
    end;

    return DrawingObject;
end;

function Esp:ViewportPoint(Position)
    return Camera:WorldToViewportPoint(Position);
end;

function Esp:Vectors(Object, Sizes)
    return {
        Top = {
            Esp:ViewportPoint((Object.CFrame * CFrame.new(-Sizes.X, Sizes.Y, -Sizes.Z)).p);
            Esp:ViewportPoint((Object.CFrame * CFrame.new(-Sizes.X, Sizes.Y, Sizes.Z)).p);
            Esp:ViewportPoint((Object.CFrame * CFrame.new(Sizes.X, Sizes.Y, Sizes.Z)).p);
            Esp:ViewportPoint((Object.CFrame * CFrame.new(Sizes.X, Sizes.Y, -Sizes.Z)).p);
        };
        Bottom = {
            Esp:ViewportPoint((Object.CFrame * CFrame.new(-Sizes.X, -Sizes.Y, -Sizes.Z)).p);
            Esp:ViewportPoint((Object.CFrame * CFrame.new(-Sizes.X, -Sizes.Y, Sizes.Z)).p);
            Esp:ViewportPoint((Object.CFrame * CFrame.new(Sizes.X, -Sizes.Y, Sizes.Z)).p);
            Esp:ViewportPoint((Object.CFrame * CFrame.new(Sizes.X, -Sizes.Y, -Sizes.Z)).p);
        };
    };
end;

function Esp:SquareVectors(Object, HeightPoint)
    local Size = Vector3.new(2, 4, 0) * ((HeightPoint.Size.Y / 2) * 2);
    return {
        A = Esp:ViewportPoint((Object.CFrame * CFrame.new(Size.X, Size.Y, 0)).p);
        B = Esp:ViewportPoint((Object.CFrame * CFrame.new(-Size.X, Size.Y, 0)).p);
        C = Esp:ViewportPoint((Object.CFrame * CFrame.new(Size.X, -Size.Y, 0)).p);
        D = Esp:ViewportPoint((Object.CFrame * CFrame.new(-Size.X, -Size.Y, 0)).p);
    };
end;

function Esp:CharacterAdded(Character, Name, Color)
    if Esp.Overrides.CharacterAddedCallback then
        return Esp.Overrides.CharacterAddedCallback(Character, Name, Color);
    end

    if Esp.Config.Enabled and not Esp.Objects[Character] then
        Esp:EspCharacter(Character, Name, Color);
    end;
end;

function Esp:GetClosestCharacter(Max)
    Max = Max or 9e9;
    local Closest;
    local Camera = Services.Workspace.CurrentCamera;
    local Mouse = Esp:GetMouse();
    for i,v in pairs(Esp:GetPlayers()) do
        if v ~= Esp:GetLocalPlayer() and Esp:GetCharacter(v) then
            local Head = game.FindFirstChild(Esp:GetCharacter(v), "Head");
            if Head then
                local Pos, Vis = Camera.WorldToScreenPoint(Camera, Head.Position);
                if Vis then
                    local Distance = (Vector2.new(Pos.X, Pos.Y) - Vector2.new(Mouse.X, Mouse.Y)).Magnitude;
                    if Distance < Max then
                        Max = Distance;
                        Closest = v;
                    end;
                end;
            end;
        end;
    end;

    if Closest then
        return Closest.Character;
    end;
end;

function Esp:CheckWall(Destination, Ignore)
    local Camera = Services.Workspace.CurrentCamera;
    local Origin = Camera.CFrame.p;
    local CheckRay = Ray.new(Origin, Destination - Origin);
    local Hit = Services.Workspace:FindPartOnRayWithIgnoreList(CheckRay, Ignore);
    return Hit == nil;
end;

function Esp.PlayerAdded(Player)
    Player.CharacterAdded:Connect(function(Character)
        if Esp.Overrides.CharacterAdded then
            return
        end;
        local Team = Esp:GetTeam(Player);
        local Color = Esp:GetTeamColor(Player);
        if Esp:GetTeam(Esp:GetLocalPlayer()) == Team and Esp.Teamcheck then
            return
        end;
        Esp:CharacterAdded(Character, Player.Name, Color);
    end);
end;

Services.Players.PlayerAdded:Connect(Esp.PlayerAdded);

function Esp:Toggle(State)
    Esp.Config.Enabled = State;

    if State then
        for i,v in pairs(Esp:GetPlayers()) do
            if v ~= Esp:GetLocalPlayer() and Esp:GetCharacter(v) then
                local Team = Esp:GetTeam(v);
                local Color = Esp:GetTeamColor(v);
                task.spawn(function()
                    if Team and Team == Esp:GetTeam(Esp:GetLocalPlayer()) and Esp.Teamcheck then
                        return
                    end;
                    Esp:CharacterAdded(Esp:GetCharacter(v), v.Name, Color);
                end);
            end;
        end;
    else
        for Char, Data in pairs(Esp.Objects) do
            Data:Change({
                Visible = false;
            });
            Data:Remove();
            Esp.Objects[Char] = nil;
        end;
    end;
end;

if not Esp.Overrides.CharacterAdded then
    for i,v in pairs(Esp:GetPlayers()) do
        if v ~= Esp:GetLocalPlayer() then
            task.spawn(function()
                Esp.PlayerAdded(v);
                if Esp:GetCharacter(v) then
                    local Team = Esp:GetTeam(v);
                    local Color = Esp:GetTeamColor(v);
                    if Team and Team == Esp:GetTeam(Esp:GetLocalPlayer()) and Esp.Teamcheck then
                        return
                    end;
                    Esp:CharacterAdded(Esp:GetCharacter(v), v.Name, Color);
                end;
            end);
        end;
    end;
end;

function Esp:ToggleTeamCheck(State)
    Esp.Teamcheck = State;
    
    if Esp.Config.Enabled and not State then
        for i,v in pairs(Esp:GetPlayers()) do
            local Team = Esp:GetTeam(v);
            if Team and Team == Esp:GetTeam(Esp:GetLocalPlayer()) and Esp:GetCharacter(v) and v ~= Esp:GetLocalPlayer() then
                Esp:EspCharacter(Esp:GetCharacter(v), v.Name, Esp:GetTeamColor(v))
            end;
        end;
    elseif State then
        for Char, Data in pairs(Esp.Objects) do
            local Player = Esp:GetPlayerFromCharacter(Char);
            local Team = Esp:GetTeam(Player);

            if Player and Team and Team == Esp:GetTeam(Esp:GetLocalPlayer()) then
                Data:Change({
                    Visible = false;
                });
                Data:Remove();
                Esp.Objects[Char] = nil;
            end;
        end;
    end;
end;

function Esp:ToggleTeamColor(State)
    Esp.TeamColor = State;
    for Char, Data in pairs(Esp.Objects) do
        local Player = Esp:GetPlayerFromCharacter(Char);

        if Player then
            local Team = Esp:GetTeam(Player);
            if State and Team then
                Data:Change({
                    Color = Esp:GetTeamColor(Player);
                });
            else
                Data:Change({
                    Color = Esp:GetTeamColor(Player);
                });
            end;
        end;
    end;
end;

function Esp:ChangeColor(Color)
    Esp.Config.Color = Color;
    for Char, Data in pairs(Esp.Objects) do
        if not Esp.TeamColor then
            Data:Change({
                Color = Color;
            });
        end;
    end;
end;

function Esp:EspPart(Object, Text)
    local Cube = {};
    local Data = {};
    local OnScreen;

    for i = 1, 6 do
        local _Drawing = Esp:Create("Quad", {
            Visible = false;
            Color = Color3.fromRGB(255, 255, 255);
            Filled = false;
            Thickness = 1;
            Transparency = 1;
        });

        table.insert(Cube, _Drawing);
    end;

    function Data:Change(Table)
        if OnScreen then
            for i,v in pairs(Table) do
                for _i,_v in pairs(Cube) do
                    _v[i] = v;
                end;
            end;
        end;
    end;

    function Data:Remove()
        Connection:Disconnect();
        Connection = nil;
        for i,v in pairs(Cube) do
            v:Remove();
        end;
    end;

    local Connection;

    local function Update()
        Connection = Services.RunService.RenderStepped:Connect(function()
            local Pos, Vis = Camera:WorldToViewportPoint(Object.Position);
            OnScreen = Vis;
            if Vis then
                local PartSizes = {
                    X = Object.Size.X / 2;
                    Y = Object.Size.Y / 2;
                    Z = Object.Size.Z / 2;
                };

                local Vectors = Esp:Vectors(Object, PartSizes);
                local Top, Bottom = Vectors.Top, Vectors.Bottom;

                --// Top
                Cube[1].PointA = Vector2.new(Top[1].X, Top[1].Y);
                Cube[1].PointB = Vector2.new(Top[2].X, Top[2].Y);
                Cube[1].PointC = Vector2.new(Top[3].X, Top[3].Y);
                Cube[1].PointD = Vector2.new(Top[4].X, Top[4].Y);

                --// Bottom
                Cube[2].PointA = Vector2.new(Bottom[1].X, Bottom[1].Y);
                Cube[2].PointB = Vector2.new(Bottom[2].X, Bottom[2].Y);
                Cube[2].PointC = Vector2.new(Bottom[3].X, Bottom[3].Y);
                Cube[2].PointD = Vector2.new(Bottom[4].X, Bottom[4].Y);

                --// Sides
                Cube[3].PointA = Vector2.new(Top[1].X, Top[1].Y);
                Cube[3].PointB = Vector2.new(Top[2].X, Top[2].Y);
                Cube[3].PointC = Vector2.new(Bottom[2].X, Bottom[2].Y);
                Cube[3].PointD = Vector2.new(Bottom[1].X, Bottom[1].Y);
                
                Cube[4].PointA = Vector2.new(Top[2].X, Top[2].Y);
                Cube[4].PointB = Vector2.new(Top[3].X, Top[3].Y);
                Cube[4].PointC = Vector2.new(Bottom[3].X, Bottom[3].Y);
                Cube[4].PointD = Vector2.new(Bottom[2].X, Bottom[2].Y)

                Cube[5].PointA = Vector2.new(Top[3].X, Top[3].Y);
                Cube[5].PointB = Vector2.new(Top[4].X, Top[4].Y);
                Cube[5].PointC = Vector2.new(Bottom[4].X, Bottom[4].Y);
                Cube[5].PointD = Vector2.new(Bottom[3].X, Bottom[3].Y);

                Cube[6].PointA = Vector2.new(Top[4].X, Top[4].Y);
                Cube[6].PointB = Vector2.new(Top[1].X, Top[1].Y);
                Cube[6].PointC = Vector2.new(Bottom[1].X, Bottom[1].Y);
                Cube[6].PointD = Vector2.new(Bottom[4].X, Bottom[4].Y);
            else
                for i,v in pairs(Cube) do
                    v.Visible = false;
                end;
            end;
        end);
    end;

    task.spawn(Update);

    return Data;
end;

function Esp:EspCharacter(Model, Text, Color)
    local Data = {};
    local Connection;
    local Box = Esp:Create("Quad", {
        Visible = false;
        Color = Color;
        Filled = false;
        Thickness = 1;
        Transparency = 1;
    });
    local Text = Esp:Create("Text", {
        Text = Text;
        Size = 16;
        Outline = true;
        Color = Color;
        Visible = false;
        Center = true;
    })
    local Tracer = Esp:Create("Line", {
        Color = Color;
        Visible = false;
        Thickness = 1;
        Transparency = 0.7;
    });

    function Data:Remove()
        Esp.Objects[Model] = nil;
        Connection:Disconnect();
        Connection = nil;
        Box:Remove();
        Text:Remove();
        Tracer:Remove();
        Box = nil;
        Text = nil;
        Tracer = nil;
    end;

    function Data:Change(Table)
        for i,v in pairs(Table) do
            Box[i] = v;
            Text[i] = v;
            Tracer[i] = v;
        end;
    end;

    local function Update()
        Connection = Services.RunService.RenderStepped:Connect(function()
            if Model then
                local RootPart = Model:FindFirstChild(Esp.Overrides.RootPartName);
                local Head = Model:FindFirstChild(Esp.Overrides.HeadName);
                if RootPart and Head then
                    local Pos, Vis = Camera:WorldToViewportPoint(RootPart.Position);
                    local HeadPos, HeadVis = Camera:WorldToViewportPoint(Head.Position);

                    if Vis then
                        local Vectors = Esp:SquareVectors(RootPart, Head);

                        Box.PointA = Vector2.new(Vectors.A.X, Vectors.A.Y);
                        Box.PointB = Vector2.new(Vectors.B.X, Vectors.B.Y);
                        Box.PointC = Vector2.new(Vectors.D.X, Vectors.D.Y);
                        Box.PointD = Vector2.new(Vectors.C.X, Vectors.C.Y);
                        Box.Visible = true;
                        if HeadVis then
                            Text.Position = Vector2.new(HeadPos.X, HeadPos.Y);
                            Text.Visible = true;
                            if Esp.Config.Tracers then
                                Tracer.Visible = true;
                                Tracer.From = Vector2.new(Services.Workspace.CurrentCamera.ViewportSize.X / 2, Services.Workspace.CurrentCamera.ViewportSize.Y / 1.2);
                                Tracer.To = Vector2.new(HeadPos.X, HeadPos.Y);
                            end
                        else
                            Text.Visible = false;
                            Tracer.Visible = false;
                        end;
                    else
                        Tracer.Visible = false;
                        Box.Visible = false;
                        Text.Visible = false;
                        Tracer.Visible = false;
                    end;
                else
                    Tracer.Visible = false;
                    Box.Visible = false;
                    Text.Visible = false;
                    Tracer.Visible = false;
                end;
            else
                Data:Remove();
            end;
        end);
    end;

    Esp.Objects[Model] = Data;

    local Humanoid = Model:FindFirstChildOfClass("Humanoid");
    if Humanoid then
        Humanoid.Died:Connect(function()
            if Box and Text then
                Box.Visible = false;
                Text.Visible = false;
                Tracer.Visible = false;
                Data:Remove();
            end;
        end);
    end;

    Model:GetPropertyChangedSignal("Parent"):Connect(function()
        if not Model.Parent and Box and Text then
            Box.Visible = false;
            Text.Visible = false;
            Tracer.Visible = false;
            Data:Remove();
        end
    end);

    task.spawn(Update);

    return Data;
end;

function Esp:ToggleFOVCircle(State)
    Esp.Config.FOVCircle = State;

    if State and not Esp.FOVCircle then
        Esp.FOVCircle = Drawing.new("Circle");
        Esp.FOVCircle.NumSides = 25;
        Esp.FOVCircle.Color = Esp.Config.FOVCircleColor;
        Esp.FOVCircle.Thickness = 1;
        Esp.FOVCircle.Radius = Esp.Config.FOVRadius
    else
        Esp.FOVCircle:Remove();
        Esp.FOVCircle = nil;
    end;
end;

function Esp:ChangeFOVCircleColor(Color)
    Esp.Config.FOVCircleColor = Color;
    if Esp.FOVCircle then
        Esp.FOVCircle.Color = Color;
    end;
end;

function Esp:ChangeFOVRadius(Value)
    Esp.Config.FOVRadius = Value;
    if Esp.FOVCircle then
        Esp.FOVCircle.Radius = Value;
    end;
end;

function Esp:DecideByChance(Chance)
    return math.random(0, 100) < Chance;
end;

Services.RunService.RenderStepped:Connect(function()
    if Esp.FOVCircle then
        Esp.FOVCircle.Visible = true;
        Esp.FOVCircle.Position = Services.UserInputService:GetMouseLocation();
    end;
end);

Esp:GetLocalPlayer():GetPropertyChangedSignal("Team"):Connect(function()
    if Esp.Config.Enabled then
        Esp:Toggle(false);
        Esp:Toggle(true);
    end;
end);

return Esp
