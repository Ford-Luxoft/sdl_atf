--- Module which provides utils interface for local file management
--
-- *Dependencies:*
--
-- *Globals:*
-- @module LocalFileUtils
-- @copyright [Ford Motor Company](https://smartdevicelink.com/partners/ford/) and [SmartDeviceLink Consortium](https://smartdevicelink.com/consortium/)
-- @license <https://github.com/smartdevicelink/sdl_core/blob/master/LICENSE>

--- Type which provides utils interface for local file management
-- @type LocalFileUtils
local LocalFileUtils = {}

--- Get local file content
-- @tparam string filePath Path to file
-- @treturn string Content of file
function LocalFileUtils.GetFileContent(filePath)
    local file = io.open(filePath, "r")
    local content = nil
    if file then
        content = file:read("*all")
        file:close()
    end
    return content
end

--- Create new local file with content
-- @tparam string filePath Path to file
-- @tparam string fileContent Content of file
function LocalFileUtils.CreateFile(filePath, fileContent)
    local file = io.open(filePath, "w")
    if file then
        file:write(fileContent)
        file:close()
    end
end

--- Delete local file
-- @tparam string filePath Path to file
function LocalFileUtils.DeleteFile(filePath)
    os.execute( " rm -f " .. filePath)
end

--- Update local file with content
-- @tparam string filePath Path to file
-- @tparam string fileContent Content of file
function LocalFileUtils.UpdateFileContent(filePath, fileContent)
    local file = io.open(filePath, "w")
    if file then
        file:write(fileContent)
        file:close()
    end
end

--- Check local file existance
-- @tparam string filePath Path to file
-- @treturn boolean Return true in case of file exists
function LocalFileUtils.IsFileExists(filePath)
    local file = io.open(pFile, "r")
    if file == nil then
      return false
    else
      file:close()
      return true
    end
end

--- Backup local file
-- @tparam string filePath Path to file
function LocalFileUtils.BackupFile(filePath)
    os.execute(" cp " .. filePath .. " " .. filePath .. "_origin")
end

--- Restore backuped local file
-- @tparam string filePath Path to file
function LocalFileUtils.RestoreFile(filePath)
    os.execute(" cp " .. filePath .. "_origin " .. filePath)
    os.execute( " rm -f " .. filePath .. "_origin")
end

--- Check folder existance
-- @tparam string pathToFolder Path to folder
-- @treturn boolean Return true in case of folder exists
function LocalFileUtils.IsFolderExists(pathToFolder)
	pathToFolder = pathToFolder .. "/"
    local ok, err, code = os.rename(file, file)
    if not ok then
        if code == 13 then
            -- Permission denied, but it exists
            return true
        end
        return false
    end
    return true
end

--- Create folder
-- @tparam string pathToFolder Path to folder
function LocalFileUtils.CreateFolder(pathToFolder)
    os.execute( "mkdir " .. pathToFolder)
end

--- Delete folder
-- @tparam string pathToFolder Path to folder
function LocalFileUtils.DeleteFolder(pathToFolder)
    os.execute( "rm -rf " .. pathToFolder)
end

return LocalFileUtils
