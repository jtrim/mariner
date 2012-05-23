RailsApp::Application.routes.draw do
  match '/foo' => 'application#foo'
  match '/bar' => 'application#bar'

  match '/normal' => 'application#normal'
  match '/condensed' => 'application#condensed'

  root :to => 'application#normal'
end
