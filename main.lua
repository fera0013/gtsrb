require 'dataset'
require 'network'
require 'training'
require 'testing'

local path = require 'pl.path'
require 'torch'

print('Reading training dataset.')
local train_dataset
local val_dataset
local test_dataset
if path.exists('train_dataset.bin') and path.exists('val_dataset.bin') then
  print('Using existing train and validation datasets.')
  train_dataset = torch.load('train_dataset.bin')
  val_dataset = torch.load('val_dataset.bin')
else
  train_dataset, val_dataset = get_dataset(false)
  torch.save('train_dataset.bin', train_dataset)
  torch.save('val_dataset.bin', val_dataset)
end
print('Using ' .. train_dataset.nbr_elements .. ' training samples.')
print('Using ' .. val_dataset.nbr_elements .. ' validation samples.')

print('Reading testing dataset.')
local test_dataset
if path.exists('test_dataset.bin') then
  print('Using existing test dataset.')
  test_dataset = torch.load('test_dataset.bin')
else
  test_dataset = get_dataset(true)
  torch.save('test_dataset.bin', test_dataset)
end
print('Using ' .. test_dataset.nbr_elements .. ' testing samples.')


local cnn
if path.exists('model.bin') then
  print('Using pretrained network.')
  cnn = torch.load('model.bin')
else
  cnn = get_network()
  print('Training network.')
  train_network(cnn, train_dataset)

  print('Saving network.')
  torch.save('model.bin', cnn)
end


print('Testing network.')
test_network(cnn, test_dataset)