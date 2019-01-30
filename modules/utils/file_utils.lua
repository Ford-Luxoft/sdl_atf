--- Module which provides utils interface for file management
--
-- *Dependencies:* `remote.remote_file_utils`, `utils.local_file_utils`
--
-- *Globals:* `config`
-- @module FileUtils
-- @copyright [Ford Motor Company](https://smartdevicelink.com/partners/ford/) and [SmartDeviceLink Consortium](https://smartdevicelink.com/consortium/)
-- @license <https://github.com/smartdevicelink/sdl_core/blob/master/LICENSE>

local remote_file_utils = require("remote/remote_file_utils")
local local_file_utils = require("utils/local_file_utils")

local FileUtils = {
    mt = { __index = {} }
}

local function isLocal(isRemoteconnectionEnabled, isForceLocal)
    return isForceLocal or not isRemoteconnectionEnabled
end

local function getPathAndName(pPathToFile)
    local pos = string.find(pPathToFile, "/[^/]*$")
    local path = string.sub(pPathToFile, 1, pos)
    local name = string.sub(pPathToFile, pos + 1)
    return path, name
end

--- Type which provides utils interface for file management
-- @type FileManager

--- Construct instance of RemoteHMIAdapter type
-- @tparam params parameters for Remote adapter
-- @treturn RemoteHMIAdapter Constructed instance
function FileUtils.FileManager(remoteConnection)
    local res = { }
    if remoteConnection then
        res.remoteFileUtils = remote_file_utils.RemoteFileUtils(remoteConnection)
    end
    setmetatable(res, FileUtils.mt)
    return res
  end

--- Check file existance
-- @tparam string filePath Path to file
-- @tparam boolean isForceLocal Force to perform action on ATF host file system
-- @treturn boolean Return true in case of file exists
function FileUtils.mt.__index:IsFileExists(filePath, isForceLocal)
    if isLocal(config.remoteConnection.enabled, isForceLocal) then
        return local_file_utils.IsFileExists(filePath)
    end

    local p, n = getPathAndName(pFile)
    local _, isExists = self.remoteFileUtils:IsFileExists(p, n)
    return isExists
end

--- Create new file with content
-- @tparam string filePath Path to file
-- @tparam boolean isForceLocal Force to perform action on ATF host file system
-- @tparam string fileContent Content of file
function FileUtils.mt.__index:CreateFile(filePath, fileContent, isForceLocal)
    if isLocal(config.remoteConnection.enabled, isForceLocal) then
        local_file_utils.CreateFile(filePath, fileContent)
        return
    end

    local p, n = getPathAndName(filePath)
    self.remoteFileUtils:CreateFile(p, n)
end

--- Delete file
-- @tparam string filePath Path to file
-- @tparam boolean isForceLocal Force to perform action on ATF host file system
function FileUtils.mt.__index:DeleteFile(filePath, isForceLocal)
    if isLocal(config.remoteConnection.enabled, isForceLocal) then
        local_file_utils.DeleteFile(filePath)
        return
    end

    local p, n = getPathAndName(filePath)
    self.remoteFileUtils:DeleteFile(p, n)
end

--- Backup file
-- @tparam string filePath Path to file
-- @tparam boolean isForceLocal Force to perform action on ATF host file system
function FileUtils.mt.__index:BackupFile(filePath, isForceLocal)
    if isLocal(config.remoteConnection.enabled, isForceLocal) then
        local_file_utils.BackupFile(filePath)
        return
    end

    local p, n = getPathAndName(filePath)
    self.remoteFileUtils:BackupFile(p, n)
end

--- Restore backuped file
-- @tparam string filePath Path to file
-- @tparam boolean isForceLocal Force to perform action on ATF host file system
function FileUtils.mt.__index:RestoreFile(filePath, isForceLocal)
    if self:IsFileExists(filePath, isForceLocal) then
        if isLocal(config.remoteConnection.enabled, isForceLocal) then
            local_file_utils.RestoreFile(filePath)
            return
        end

        local p, n = getPathAndName(filePath)
        self.remoteFileUtils:RestoreFile(p, n)
    end
end

--- Update file with content
-- @tparam string filePath Path to file
-- @tparam boolean isForceLocal Force to perform action on ATF host file system
-- @tparam string fileContent Content of file
function FileUtils.mt.__index:UpdateFileContent(filePath, fileContent, isForceLocal)
    if isLocal(config.remoteConnection.enabled, isForceLocal) then
        local_file_utils.UpdateFileContent(filePath, fileContent)
        return
    end

    local p, n = getPathAndName(filePath)
    self.remoteFileUtils:UpdateFileContent(p, n, fileContent)
end

--- Get file content
-- @tparam string filePath Path to file
-- @tparam boolean isForceLocal Force to perform action on ATF host file system
-- @treturn string Content of file
function FileUtils.mt.__index:GetFileContent(filePath, isForceLocal)
    if isLocal(config.remoteConnection.enabled, isForceLocal) then
        return local_file_utils.GetFileContent(filePath)
    end

    local p, n = getPathAndName(filePath)
    local _, isExists = self.remoteFileUtils:IsFileExists(p, n)
    if isExists then
        local _, path = self.remoteFileUtils:GetFile(p, n)
        filePath = path
    else
        return nil
    end
    local content = local_file_utils.GetFileContent(filePath)
    local_file_utils.DeleteFile(filePath)
    return content
end

--- Check folder existance
-- @tparam string pathToFolder Path to folder
-- @tparam boolean isForceLocal Force to perform action on ATF host file system
-- @treturn boolean Return true in case of folder exists
function FileUtils.mt.__index:IsFolderExists(pathToFolder, isForceLocal)
    if isLocal(config.remoteConnection.enabled, isForceLocal) then
        local_file_utils.IsFolderExists(pathToFolder)
        return
    end

    self.remoteFileUtils:IsFolderExists(pathToFolder)
end

--- Create folder
-- @tparam string pathToFolder Path to folder
-- @tparam boolean isForceLocal Force to perform action on ATF host file system
function FileUtils.mt.__index:CreateFolder(pathToFolder, isForceLocal)
    if isLocal(config.remoteConnection.enabled, isForceLocal) then
        local_file_utils.CreateFolder(pathToFolder)
        return
    end

    self.remoteFileUtils:CreateFolder(pathToFolder)
end

--- Delete folder
-- @tparam string pathToFolder Path to folder
-- @tparam boolean isForceLocal Force to perform action on ATF host file system
function FileUtils.mt.__index:DeleteFolder(pathToFolder, isForceLocal)
    if isLocal(config.remoteConnection.enabled, isForceLocal) then
        local_file_utils.DeleteFolder(pathToFolder)
        return
    end

    self.remoteFileUtils:DeleteFolder(pathToFolder)
end

return FileUtils
