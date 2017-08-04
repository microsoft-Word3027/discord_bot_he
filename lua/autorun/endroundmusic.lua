KuroEndRoundMusic = {}

function KuroEndRoundMusic:Initialize()
	if SERVER then
		if (file.Exists("sound", "GAME")) then
			if (file.Exists("sound/endroundmusic", "GAME")) then
				if (!file.Exists("sound/endroundmusic/traitor", "GAME") and !file.Exists("sound/endroundmusic/innocent", "GAME") and !file.Exists("sound/endroundmusic/timeout", "GAME")) then
					KuroEndRoundMusic.noWinTypeFolders = true
				else
					KuroEndRoundMusic.songs = {}
					KuroEndRoundMusic.songs[WIN_INNOCENT] = {}
					KuroEndRoundMusic.songs[WIN_TIMELIMIT] = {}
					KuroEndRoundMusic.songs[WIN_TRAITOR] = {}
					KuroEndRoundMusic.lastSongs = {[WIN_TRAITOR] = -1, [WIN_INNOCENT] = -1, [WIN_TIMELIMIT] = -1}
					KuroEndRoundMusic.CSStrings = {[WIN_TRAITOR] = "t", [WIN_TIMELIMIT] = "to", [WIN_INNOCENT] = "i"}
					KuroEndRoundMusic.songCount = 0
					KuroEndRoundMusic.songCounts = {[WIN_TRAITOR] = 0, [WIN_INNOCENT] = 0, [WIN_TIMELIMIT] = 0}

					local title, author = nil, nil
					local files, directories = file.Find("sound/endroundmusic/traitor/*", "GAME")
					for _, v in pairs (files) do
						if (string.GetExtensionFromFilename(v) != "txt") then
							if (file.Exists("sound/endroundmusic/traitor/"..string.StripExtension(v)..".txt", "GAME")) then
								local lines = string.Explode("\n", string.Replace(file.Read("sound/endroundmusic/traitor/"..string.StripExtension(v)..".txt", "GAME"), "\r", ""))
								title, author = lines[1], lines[2]
								if !title or string.Trim(title) == "" then title = "TITLE ERROR!!!" end
								if !author or string.Trim(author) == "" then author = "AUTHOR ERROR!!!" end
							end
							local path = "endroundmusic/traitor/"..v;
							resource.AddFile("sound/"..path)
							table.insert(KuroEndRoundMusic.songs[WIN_TRAITOR], {path = path, title = title, author = author})
							KuroEndRoundMusic.songCount = KuroEndRoundMusic.songCount + 1
							KuroEndRoundMusic.songCounts[WIN_TRAITOR] = KuroEndRoundMusic.songCounts[WIN_TRAITOR] + 1
						end
					end

					title, author = nil, nil
					files, directories = file.Find("sound/endroundmusic/timeout/*", "GAME")
					for _, v in pairs (files) do
						if (string.GetExtensionFromFilename(v) != "txt") then
							if (file.Exists("sound/endroundmusic/timeout/"..string.StripExtension(v)..".txt", "GAME")) then
								local lines = string.Explode("\n", string.Replace(file.Read("sound/endroundmusic/timeout/"..string.StripExtension(v)..".txt", "GAME"), "\r", ""))
								title, author = lines[1], lines[2]
								if !title or string.Trim(title) == "" then title = "TITLE ERROR!!!" end
								if !author or string.Trim(author) == "" then author = "AUTHOR ERROR!!!" end
							end
							local path = "endroundmusic/timeout/"..v;
							resource.AddFile("sound/"..path)
							table.insert(KuroEndRoundMusic.songs[WIN_TIMELIMIT], {path = path, title = title, author = author})
							KuroEndRoundMusic.songCount = KuroEndRoundMusic.songCount + 1
							KuroEndRoundMusic.songCounts[WIN_TIMELIMIT] = KuroEndRoundMusic.songCounts[WIN_TIMELIMIT] + 1
						end
					end

					title, author = nil, nil
					files, directories = file.Find("sound/endroundmusic/innocent/*", "GAME")
					for _, v in pairs (files) do
						if (string.GetExtensionFromFilename(v) != "txt") then
							if (file.Exists("sound/endroundmusic/innocent/"..string.StripExtension(v)..".txt", "GAME")) then
								local lines = string.Explode("\n", string.Replace(file.Read("sound/endroundmusic/innocent/"..string.StripExtension(v)..".txt", "GAME"), "\r", ""))
								title, author = lines[1], lines[2]
								if !title or string.Trim(title) == "" then title = "TITLE ERROR!!!" end
								if !author or string.Trim(author) == "" then author = "AUTHOR ERROR!!!" end
							end
							local path = "endroundmusic/innocent/"..v;
							resource.AddFile("sound/"..path)
							table.insert(KuroEndRoundMusic.songs[WIN_INNOCENT], {path = path, title = title, author = author})
							KuroEndRoundMusic.songCount = KuroEndRoundMusic.songCount + 1
							KuroEndRoundMusic.songCounts[WIN_INNOCENT] = KuroEndRoundMusic.songCounts[WIN_INNOCENT] + 1
						end
					end

					if (KuroEndRoundMusic.songCount == 0) then
						KuroEndRoundMusic.noSongs = true;
					end
				end
			else
				KuroEndRoundMusic.noEndRoundMusicFolder = true
			end
		else
			KuroEndRoundMusic.noSoundFolder = true
		end

		util.AddNetworkString("KuroEndRoundMusic")
		util.AddNetworkString("KuroEndRoundMusicError")

		hook.Add("TTTEndRound", "KuroEndRoundMusic",
			function(result)
				if ((KuroEndRoundMusic.noSoundFolder or KuroEndRoundMusic.noEndRoundMusicFolder) and !KuroEndRoundMusic.errorDisplayed and file.Exists("endroundsounds", "DATA")) then
					KuroEndRoundMusic.errorDisplayed = true;
					net.Start("KuroEndRoundMusicError")
						net.WriteString("It would seem like this server is still using an outdated version of this addon. It has been completely rescripted as of 28/07/2016. Please visit the workshop page.")
					net.Broadcast()
					return;
				end

				if (KuroEndRoundMusic.noSoundFolder and !KuroEndRoundMusic.errorDisplayed) then
					KuroEndRoundMusic.errorDisplayed = true;
					net.Start("KuroEndRoundMusicError")
						net.WriteString("No \"sound\" folder found inside the garrysmod root! Garry's Mod cannot create it for you.")
					net.Broadcast()
					return;
				end

				if (KuroEndRoundMusic.noEndRoundMusicFolder and !KuroEndRoundMusic.errorDisplayed) then
					KuroEndRoundMusic.errorDisplayed = true;
					net.Start("KuroEndRoundMusicError")
						net.WriteString("No \"endroundmusic\" folder found inside \"garrysmod\\sound\"! Garry's Mod cannot create it for you.")
					net.Broadcast()
					return;
				end

				if (KuroEndRoundMusic.noWinTypeFolders and !KuroEndRoundMusic.errorDisplayed) then
					KuroEndRoundMusic.errorDisplayed = true;
					net.Start("KuroEndRoundMusicError")
						net.WriteString("None of the following folders found inside \"garrysmod\\sound\\endroundmusic\": \"innocent\", \"timeout\", \"traitor\"! Garry's Mod cannot create them for you.")
					net.Broadcast()
					return;
				end

				if (KuroEndRoundMusic.noSongs and !KuroEndRoundMusic.errorDisplayed) then
					KuroEndRoundMusic.errorDisplayed = true;
					net.Start("KuroEndRoundMusicError")
						net.WriteString("No songs were found! Make sure you add some music files in the appropriate folders you created. You pair each music file with a .txt file of the same name, containing the song title on the first line and the author on the second.")
					net.Broadcast()
					return;
				end

				if (KuroEndRoundMusic.errorDisplayed) then return end;

				local songCount = KuroEndRoundMusic.songCounts[result]
				if (songCount == 0) then return end;

				net.Start("KuroEndRoundMusic")
					randomSongIndex = math.max(1, math.random(1, songCount))

					if (songCount > 1) then
						while (randomSongIndex == KuroEndRoundMusic.lastSongs[result]) do
							randomSongIndex = math.max(1, math.random(1, songCount))
						end
					end
					KuroEndRoundMusic.lastSongs[result] = randomSongIndex;

					local song = KuroEndRoundMusic.songs[result][randomSongIndex]
					local info = song.title and song.author
					net.WriteBool(info)
					net.WriteString(song.path)
					if (info) then
						net.WriteString(song.title)
						net.WriteString(song.author)
						net.WriteString(KuroEndRoundMusic.CSStrings[result])
					end
				net.Broadcast()
			end
		)
	else
		net.Receive("KuroEndRoundMusic", function(_)
			local info = net.ReadBool()
			local path = net.ReadString()
			surface.PlaySound(path)
			local title
			local author
			if (info) then
				title, author, winType = net.ReadString(), net.ReadString(), net.ReadString()
				KuroEndRoundMusic.title = title
				KuroEndRoundMusic.author = author
				KuroEndRoundMusic.paintBox = true
				KuroEndRoundMusic.boxStatus = 0
				KuroEndRoundMusic.winType = winType
			end
		end)

		net.Receive("KuroEndRoundMusicError",
			function(_)
				chat.AddText(Color(255, 0, 0), "[EndRoundMusic Error]: ", Color(255, 255, 255), net.ReadString())
			end
		)

		KuroEndRoundMusic.title = nil
		KuroEndRoundMusic.author = nil
		KuroEndRoundMusic.paintBox = false
		KuroEndRoundMusic.boxStatus = 0
		KuroEndRoundMusic.colors = {i = Color(0, 255, 0, 255), t = Color(255, 0, 0, 255), to = Color(255, 255, 0, 255), ["white"] = Color(255, 255, 255, 255)}
		KuroEndRoundMusic.winType = "white"

		hook.Add("HUDPaint", "KuroEndRoundMusicTitleBox",
			function()
				if (KuroEndRoundMusic.paintBox) then
					local fraction = 0
					if (KuroEndRoundMusic.boxStatus <= 1) then
						fraction = KuroEndRoundMusic.boxStatus
					elseif (KuroEndRoundMusic.boxStatus <= 6) then
						fraction = 1
					elseif (KuroEndRoundMusic.boxStatus <= 7) then
						fraction = math.max(1 - (KuroEndRoundMusic.boxStatus - 6), 0)
					elseif (KuroEndRoundMusic.boxStatus > 7) then
						KuroEndRoundMusic.boxStatus = 0
						KuroEndRoundMusic.paintBox = false
					end

					surface.SetDrawColor(0, 0, 0, 200)
					surface.SetFont("Trebuchet24")
					local width1, height1 = surface.GetTextSize(KuroEndRoundMusic.title)
					local width2, height2 = surface.GetTextSize(KuroEndRoundMusic.author)
					local width = math.max(width1, width2) + 10

					surface.DrawRect(-width + (width * fraction), 25, width, height1 + height2 + 15)
					surface.SetDrawColor(255, 255, 255, 255)
					surface.SetTextColor(KuroEndRoundMusic.colors[KuroEndRoundMusic.winType])
					surface.SetTextPos(-width + (width * fraction) + 5, 25 + 5)
					surface.DrawText(KuroEndRoundMusic.author)
					surface.SetTextColor(KuroEndRoundMusic.colors.white)
					surface.SetTextPos(-width + (width * fraction) + 5, 5 + height1 + 5 + 25)
					surface.DrawText(KuroEndRoundMusic.title)
					KuroEndRoundMusic.boxStatus = KuroEndRoundMusic.boxStatus + FrameTime()
				end
			end
		)
	end
end

hook.Add("Initialize", "EndRoundMusicInit", KuroEndRoundMusic.Initialize)