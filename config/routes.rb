Rails.application.routes.draw do
	get 'keyboard' => 'spiders#keyboard'
	post 'message' => 'spiders#keyboard'
end
