-- Function Declarations
--[[
local addEvenDistributionForArguments
local distributeEvenly
local handleSlashCommands
local itemCountsTableForItemId
local itemTableFromLink
local split
local totalCountFromTable
--]]
EvenDistribution = { }

-- Slash Commands
SLASH_EVENDISTRIBUTION1 = '/ed';
SLASH_EVENDISTRIBUTION2 = '/evendistribution';

-- Event Frame
local EvenDistributionEventFrame = CreateFrame("Frame")

-- Slash Command Handling
handleSlashCommands = function(message, editbox)
	local command, rest = message:match("^(%S*)%s*(.-)$");
	if command == "add" then
		addEvenDistributionForArguments(EvenDistribution:split(rest))
	end
end
SlashCmdList["EVENDISTRIBUTION"] = handleSlashCommands;

-- Operational
addEvenDistributionForArguments = function(argumentList)
	local itemID = argumentList[0]
	local characterName = argumentList[1]

	print('adding '..characterName..' to '..itemID)

	if type(EvenlyDistributeItems) ~= "table" then
		EvenlyDistributeItems = { }
	end

	if EvenlyDistributeItems[itemID] == nil then
		EvenlyDistributeItems[itemID] = { }
	end

	EvenlyDistributeItems[itemID][#t+1] = characterName
end

distributeEvenly = function(self, event)
	print('Mailbox opened')
	for itemID, characters in pairs(EvenlyDistributeItems) do
		local itemCounts = EvenDistribution:itemCountsTableForItemId(itemID)
		local totalCount = EvenDistribution:totalCountFromTable(itemCounts)

		local evenDistribution = floor(totalCount / #characters)

		print('each char needs '..evenDistribution)
	end
end

-- Helper Functions
function EvenDistribution:itemCountsTableForItemId(itemId)

   local itemCounts = { }

   for characterName,characterInfo in pairs(DataStore_ContainersDB['global']['Characters']) do

      local containers = characterInfo['Containers']
      
      if containers ~= nil then
         
         local characterCount = 0
         
         for bagName,bagTable in pairs(containers) do
            
            local ids = bagTable['ids']
            local counts = bagTable['counts']
            
            for i, id in ipairs(ids) do
               if id == tonumber(itemId) then
                  
                  local count = counts[i]
                  
                  if count ~= nil then
                     characterCount = characterCount + count
                  end
               end
               
            end
         end
         
         itemCounts[characterName] = characterCount
      end
   end
   
   return itemCounts
end

function EvenDistribution:itemTableFromLink(itemLink)

	local _, _, color, iType, id, enchant, gem1, gem2, gem3, gem4,
	suffix, unique, linkLvl, name = string.find(itemLink,
	"|?c?f?f?(%x*)|?H?([^:]*):?(%d+):?(%d*):?(%d*):?(%d*):?(%d*):?(%d*):?(%-?%d*):?(%-?%d*):?(%d*):?(%d*):?(%-?%d*)|?h?%[?([^%[%]]*)%]?|?h?|?r?")

	local table = { }

	table['color'] = color
	table['iType'] = iType
	table['id'] = id
	table['enchant'] = enchant
	table['gem1'] = gem1
	table['gem2'] = gem2
	table['gem3'] = gem3
	table['gem4'] = gem4
	table['suffix'] = suffix
	table['unique'] = unique
	table['linkLvl'] = linkLvl
	table['name'] = name

	return table
end

function EvenDistribution:split(inputstr, sep)

	if sep == nil then
		sep = "%s"
	end

	local t={} ; i=0

	for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
		t[i] = str
		i = i + 1
	end

	return t
end

function EvenDistribution:totalCountFromTable(table)

	local totalCount = 0

	for k,v in pairs(table) do
		totalCount = totalCount + v
	end

	return totalCount
end

-- Event Registering and handling
EvenDistributionEventFrame:RegisterEvent("MAIL_SHOW")
EvenDistributionEventFrame:SetScript("OnEvent", distributeEvenly)
