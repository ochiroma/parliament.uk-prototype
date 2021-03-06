require 'rails_helper'

RSpec.describe PartiesController, vcr: true do
  describe 'GET index' do
    before(:each) do
      get :index
    end

    it 'should have a response with http status ok (200)' do
      expect(response).to have_http_status(:ok)
    end

    it 'assigns @parties and @letters' do
      assigns(:parties).each do |party|
        expect(party).to be_a(Grom::Node)
        expect(party.type).to eq('http://id.ukpds.org/schema/Party')
      end

      expect(assigns(:letters)).to be_a(Array)
    end

    it 'assigns @parties in alphabetical order' do
      expect(assigns(:parties)[0].name).to eq('A')
      expect(assigns(:parties)[1].name).to eq('AC')
    end

    it 'renders the index template' do
      expect(response).to render_template('index')
    end
  end

  describe 'GET lookup' do
    before(:each) do
      get :lookup, params: { source: 'mnisId', id: '96' }
    end

    it 'should have a response with http status redirect (302)' do
      expect(response).to have_http_status(302)
    end

    it 'assigns @party' do
      expect(assigns(:party)).to be_a(Grom::Node)
      expect(assigns(:party).type).to eq('http://id.ukpds.org/schema/Party')
    end

    it 'redirects to parties/:id' do
      expect(response).to redirect_to(party_path('9fc46fca-4a66-4fa9-a4af-d4c2bf1a2703'))
    end
  end

  describe 'GET current' do
    before(:each) do
      get :current
    end

    it 'should have a response with http status ok (200)' do
      expect(response).to have_http_status(:ok)
    end

    it 'should return the current number of parties' do
      expect(assigns(:parties).size).to eq(13)
    end

    it 'assigns @parties' do
      assigns(:parties).each do |party|
        expect(party).to be_a(Grom::Node)
        expect(party.type).to eq('http://id.ukpds.org/schema/Party')
      end
    end

    it 'assigns @parties in alphabetical order' do
      expect(assigns(:parties)[0].name).to eq('Conservative')
      expect(assigns(:parties)[1].name).to eq('Democratic Unionist Party')
    end

    it 'renders the current template' do
      expect(response).to render_template('current')
    end
  end

  describe 'GET show' do
    before(:each) do
      get :show, params: {party_id: 'f4e62fb8-2cf4-41b2-b7a3-7e621522a30d'}
    end

    it 'response have a response with http status ok (200)' do
      expect(response).to have_http_status(:ok)
    end

    it 'assigns @party' do
      expect(assigns(:party)).to be_a(Grom::Node)
      expect(assigns(:party).type).to eq('http://id.ukpds.org/schema/Party')
    end

    it 'renders the show template' do
      expect(response).to render_template('show')
    end
  end

  describe 'GET members' do
    before(:each) do
      get :members, params: { party_id: '7a048f56-0ddd-48b0-85bd-cf5dd9fa5427' }
    end

    it 'should have a response with http status ok (200)' do
      expect(response).to have_http_status(:ok)
    end

    it 'assigns @party, @people and @letters' do
      expect(assigns(:party)).to be_a(Grom::Node)
      expect(assigns(:party).type).to eq('http://id.ukpds.org/schema/Party')
      expect(assigns(:letters)).to be_a(Array)

      assigns(:people).each do |person|
        expect(person).to be_a(Grom::Node)
        expect(person.type).to eq('http://id.ukpds.org/schema/Person')
      end
    end

    it 'assigns @people in alphabetical order' do
      expect(assigns(:people)[0].given_name).to eq('Person 1')
      expect(assigns(:people)[1].given_name).to eq('Person 2')
    end

    it 'renders the members template' do
      expect(response).to render_template('members')
    end
  end

  describe 'GET current members' do
    before(:each) do
      get :current_members, params: { party_id: '7a048f56-0ddd-48b0-85bd-cf5dd9fa5427' }
    end

    it 'should have a response with http status ok (200)' do
      expect(response).to have_http_status(:ok)
    end

    it 'assigns @party, @people and @letters' do
      expect(assigns(:party)).to be_a(Grom::Node)
      expect(assigns(:party).type).to eq('http://id.ukpds.org/schema/Party')
      expect(assigns(:letters)).to be_a(Array)

      assigns(:people).each do |person|
        expect(person).to be_a(Grom::Node)
        expect(person.type).to eq('http://id.ukpds.org/schema/Person')
      end
    end

    it 'assigns @people in alphabetical order' do
      expect(assigns(:people)[0].given_name).to eq('Person 1')
      expect(assigns(:people)[1].given_name).to eq('Person 2')
    end

    it 'renders the current_members template' do
      expect(response).to render_template('current_members')
    end
  end

  describe 'GET letters' do
    before(:each) do
      get :letters, params: { letter: 'l' }
    end

    it 'should have a response with http status ok (200)' do
      expect(response).to have_http_status(:ok)
    end

    it 'assigns @parties and @letters' do
      assigns(:parties).each do |party|
        expect(party).to be_a(Grom::Node)
        expect(party.type).to eq('http://id.ukpds.org/schema/Party')
      end

      expect(assigns(:letters)).to be_a(Array)
    end

    it 'assigns @parties in alphabetical order' do
      expect(assigns(:parties)[0].name).to eq('Labour')
      expect(assigns(:parties)[1].name).to eq('Labour Independent')
    end

    it 'renders the letters template' do
      expect(response).to render_template('letters')
    end

    context 'invalid parties' do
      before(:each) do
        get :letters, params: { letter: 'x' }
      end

      it 'should return a 200 status' do
        expect(response).to have_http_status(200)
      end

      it 'should populate @parties with an empty array' do
        expect(controller.instance_variable_get(:@parties)).to be_empty
      end
    end

  end

  describe 'GET members_letters' do
    before(:each) do
      get :members_letters, params: { party_id: 'f4e62fb8-2cf4-41b2-b7a3-7e621522a30d', letter: 'a' }
    end

    it 'should have a response with http status ok (200)' do
      expect(response).to have_http_status(:ok)
    end

    it 'assigns @party, @people and @letters' do
      expect(assigns(:party)).to be_a(Grom::Node)
      expect(assigns(:party).type).to eq('http://id.ukpds.org/schema/Party')
      expect(assigns(:letters)).to be_a(Array)

      assigns(:people).each do |person|
        expect(person).to be_a(Grom::Node)
        expect(person.type).to eq('http://id.ukpds.org/schema/Person')
      end
    end

    it 'assigns @people in alphabetical order' do
      expect(assigns(:people)[0].sort_name).to eq('Abbott, Ms Diane')
      expect(assigns(:people)[1].sort_name).to eq('Abrahams, Debbie')
    end

    it 'renders the members_letters template' do
      expect(response).to render_template('members_letters')
    end
  end

  describe 'GET current_members_letters' do
    before(:each) do
      get :current_members_letters, params: { party_id: 'f4e62fb8-2cf4-41b2-b7a3-7e621522a30d', letter: 'c' }
    end

    it 'should have a response with http status ok (200)' do
      expect(response).to have_http_status(:ok)
    end

    it 'assigns @party, @people and @letters' do
      expect(assigns(:party)).to be_a(Grom::Node)
      expect(assigns(:party).type).to eq('http://id.ukpds.org/schema/Party')
      expect(assigns(:letters)).to be_a(Array)

      assigns(:people).each do |person|
        expect(person).to be_a(Grom::Node)
        expect(person.type).to eq('http://id.ukpds.org/schema/Person')
      end
    end

    it 'assigns @people in alphabetical order' do
      expect(assigns(:people)[0].sort_name).to eq('Cadbury, Ruth')
      expect(assigns(:people)[1].sort_name).to eq('Campbell, Mr Alan')
    end

    it 'renders the current_members_letters template' do
      expect(response).to render_template('current_members_letters')
    end
  end

  describe "GET a_to_z" do
    before(:each) do
      get :a_to_z
    end

    it 'should have a response with http status ok (200)' do
      expect(response).to have_http_status(:ok)
    end

    it 'assigns @letters' do
      expect(assigns(:letters)).to be_a(Array)
    end

    it 'renders the a_to_z template' do
      expect(response).to render_template('a_to_z')
    end
  end

  describe "GET a_to_z_members" do
    before(:each) do
      get :a_to_z_members, params: { party_id: 'f4e62fb8-2cf4-41b2-b7a3-7e621522a30d' }
    end

    it 'should have a response with http status ok (200)' do
      expect(response).to have_http_status(:ok)
    end

    it 'assigns @letters' do
      expect(assigns(:letters)).to be_a(Array)
    end

    it 'renders the a_to_z_members template' do
      expect(response).to render_template('a_to_z_members')
    end
  end

  describe "GET a_to_z_current_members" do
    before(:each) do
      get :a_to_z_current_members, params: { party_id: 'f4e62fb8-2cf4-41b2-b7a3-7e621522a30d' }
    end

    it 'should have a response with http status ok (200)' do
      expect(response).to have_http_status(:ok)
    end

    it 'assigns @letters' do
      expect(assigns(:letters)).to be_a(Array)
    end

    it 'renders the a_to_z_current_members template' do
      expect(response).to render_template('a_to_z_current_members')
    end
  end

  describe 'GET lookup_by_letters' do
    context 'it returns multiple results' do
      before(:each) do
        get :lookup_by_letters, params: {letters: 'labour'}
      end

      it 'should have a response with http status redirect (302)' do
        expect(response).to have_http_status(302)
      end

      it 'redirects to parties/a-z/labour' do
        expect(response).to redirect_to(parties_a_z_letter_path(letter: 'labour'))
      end
    end

    context 'it returns a single result' do
      before(:each) do
        get :lookup_by_letters, params: {letters: 'guildford'}
      end

      it 'should have a response with http status redirect (302)' do
        expect(response).to have_http_status(302)
      end

      it 'redirects to people/:id' do
        expect(response).to redirect_to(party_path('cd1f1624-a361-4e1f-92b7-9abf5378d953'))
      end
    end
  end
end
