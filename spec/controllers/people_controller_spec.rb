require 'rails_helper'

RSpec.describe PeopleController, vcr: true do

  describe 'GET index' do
    before(:each) do
      get :index
    end

    it 'should have a response with http status ok (200)' do
      expect(response).to have_http_status(:ok)
    end

    it 'assigns @people and @letters' do
      assigns(:people).each do |person|
        expect(person).to be_a(Grom::Node)
        expect(person.type).to eq('http://id.ukpds.org/schema/Person')
      end

      expect(assigns(:letters)).to be_a(Array)
    end

    it 'assigns @people in alphabetical order' do
      expect(assigns(:people)[0].given_name).to eq('Person 1 - forename')
      expect(assigns(:people)[1].given_name).to eq('Person 2 - forename')
    end

    it 'renders the index template' do
      expect(response).to render_template('index')
    end
  end

  describe 'GET lookup' do
    before(:each) do
      get :lookup, params: { source: 'mnisId', id: '3898' }
    end

    it 'should have a response with http status redirect (302)' do
      expect(response).to have_http_status(302)
    end

    it 'assigns @person' do
      expect(assigns(:person)).to be_a(Grom::Node)
      expect(assigns(:person).type).to eq('http://id.ukpds.org/schema/Person')
    end

    it 'redirects to people/:id' do
      expect(response).to redirect_to(person_path('581ade57-3805-4a4a-82c9-8d622cb352a4'))
    end
  end

  describe "GET show" do
    before(:each) do
      get :show, params: { person_id: '626b57f9-6ef0-475a-ae12-40a44aca7eff' }
    end

    it 'should have a response with http status ok (200)' do
      expect(response).to have_http_status(:ok)
    end

    it 'assigns @person, @seat_incumbencies, @house_incumbencies, @current_party_membership,
    @most_recent_incumbency and @current_incumbency' do
      expect(assigns(:person)).to be_a(Grom::Node)
      expect(assigns(:person).type).to eq('http://id.ukpds.org/schema/Person')

      assigns(:seat_incumbencies).each do |seat_incumbency|
        expect(seat_incumbency).to be_a(Grom::Node)
        expect(seat_incumbency.type).to eq('http://id.ukpds.org/schema/SeatIncumbency')
      end

      assigns(:house_incumbencies).each do |house_incumbency|
        expect(house_incumbency).to be_a(Grom::Node)
        expect(house_incumbency.type).to eq('http://id.ukpds.org/schema/HouseIncumbency')
      end

      expect(assigns(:current_party_membership)).to be_a(Grom::Node)
      expect(assigns(:current_party_membership).type).to eq('http://id.ukpds.org/schema/PartyMembership')
      expect(assigns(:current_party_membership).current?).to be(true)

      expect(assigns(:most_recent_incumbency)).to be_a(Grom::Node)
      expect(assigns(:most_recent_incumbency).end_date).to be(nil)

      expect(assigns(:current_incumbency)).to be_a(Grom::Node)
      expect(assigns(:current_incumbency).current?).to be(true)
    end

    it 'renders the show template' do
      expect(response).to render_template('show')
    end
  end

  describe "GET members" do
    before(:each) do
      get :members
    end

    it 'should have a response with http status ok (200)' do
      expect(response).to have_http_status(:ok)
    end

    it 'assigns @people and @letters' do
      assigns(:people).each do |person|
        expect(person).to be_a(Grom::Node)
        expect(person.type).to eq('http://id.ukpds.org/schema/Person')
      end

      expect(assigns(:letters)).to be_a(Array)
    end

    it 'assigns @people in alphabetical order' do
      expect(assigns(:people)[0].given_name).to eq('Person 1 - forename')
      expect(assigns(:people)[1].given_name).to eq('Person 2 - forename')
    end

    it 'renders the members template' do
      expect(response).to render_template('members')
    end
  end

  describe "GET current_members" do
    before(:each) do
      get :current_members
    end

    it 'should have a response with http status ok (200)' do
      expect(response).to have_http_status(:ok)
    end

    it 'assigns @people and @letters' do
      assigns(:people).each do |person|
        expect(person).to be_a(Grom::Node)
        expect(person.type).to eq('http://id.ukpds.org/schema/Person')
      end

      expect(assigns(:letters)).to be_a(Array)
    end

    it 'assigns @people in alphabetical order' do
      expect(assigns(:people)[0].given_name).to eq('Person 1 - givenName')
      expect(assigns(:people)[1].given_name).to eq('Person 2 - givenName')
    end

    it 'renders the current_members template' do
      expect(response).to render_template('current_members')
    end
  end

  describe "GET contact_points" do
    before(:each) do
      get :contact_points, params: { person_id: '08a3dfac-652a-44d6-8a43-00bb13c60e47' }
    end

    it 'should have a response with http status ok (200)' do
      expect(response).to have_http_status(:ok)
    end

    it 'assigns @person and @contact_points' do
      expect(assigns(:person)).to be_a(Grom::Node)
      expect(assigns(:person).type).to eq('http://id.ukpds.org/schema/Person')
      assigns(:contact_points).each do |contact_point|
        expect(contact_point).to be_a(Grom::Node)
        expect(contact_point.type).to eq('http://id.ukpds.org/schema/ContactPoint')
      end
    end

    it 'renders the contact_points template' do
      expect(response).to render_template('contact_points')
    end
  end

  describe "GET parties" do
    before(:each) do
      get :parties, params: {person_id: 'a9bd4923-9964-4196-b6b7-e42ada6e5284'}
    end

    it 'should have a response with http status ok (200)' do
      expect(response).to have_http_status(:ok)
    end

    it 'assigns @person and @party_memberships' do
      expect(assigns(:person)).to be_a(Grom::Node)
      expect(assigns(:person).type).to eq('http://id.ukpds.org/schema/Person')

      assigns(:party_memberships).each do |party_membership|
        expect(party_membership).to be_a(Grom::Node)
        expect(party_membership.type).to eq('http://id.ukpds.org/schema/PartyMembership')
      end
    end

    it 'assigns @party_memberships in reverse chronological order' do
      expect(assigns(:party_memberships)[0].start_date).to eq(DateTime.new(2015, 5, 7))
      expect(assigns(:party_memberships)[1].start_date).to eq(DateTime.new(2014, 10, 9))
    end

    it 'renders the parties template' do
      expect(response).to render_template('parties')
    end
  end

  describe "GET current_party" do
    before(:each) do
      get :current_party, params: { person_id: '626b57f9-6ef0-475a-ae12-40a44aca7eff' }
    end

    it 'should have a response with http status ok (200)' do
      expect(response).to have_http_status(:ok)
    end

    it 'assigns @person and @party' do
      expect(assigns(:person)).to be_a(Grom::Node)
      expect(assigns(:person).type).to eq('http://id.ukpds.org/schema/Person')
      expect(assigns(:party)).to be_a(Grom::Node)
      expect(assigns(:party).type).to eq('http://id.ukpds.org/schema/Party')
    end

    it 'renders the current_party template' do
      expect(response).to render_template('current_party')
    end
  end

  describe "GET constituencies" do
    before(:each) do
      get :constituencies, params: { person_id: '626b57f9-6ef0-475a-ae12-40a44aca7eff' }
    end

    it 'should have a response with http status ok (200)' do
      expect(response).to have_http_status(:ok)
    end

    it 'assigns @person and @seat_incumbencies' do
      expect(assigns(:person)).to be_a(Grom::Node)
      expect(assigns(:person).type).to eq('http://id.ukpds.org/schema/Person')
      assigns(:seat_incumbencies).each do |seat_incumbency|
        expect(seat_incumbency).to be_a(Grom::Node)
        expect(seat_incumbency.type).to eq('http://id.ukpds.org/schema/SeatIncumbency')
      end
    end

    it 'assigns @seat_incumbencies in reverse chronological order' do
      expect(assigns(:seat_incumbencies)[0].start_date).to eq(DateTime.new(2010, 5, 6))
      expect(assigns(:seat_incumbencies)[1].start_date).to eq(DateTime.new(2005, 5, 5))
    end

    it 'renders the parties template' do
      expect(response).to render_template('constituencies')
    end
  end

  describe "GET current_constituency" do
    before(:each) do
      get :current_constituency, params: { person_id: 'ff75cd0c-1a8b-49ab-8292-f00d153588e5' }
    end

    it 'should have a response with http status ok (200)' do
      expect(response).to have_http_status(:ok)
    end

    it 'assigns @person and @constituency' do
      expect(assigns(:person)).to be_a(Grom::Node)
      expect(assigns(:person).type).to eq('http://id.ukpds.org/schema/Person')
      expect(assigns(:constituency)).to be_a(Grom::Node)
      expect(assigns(:constituency).type).to eq('http://id.ukpds.org/schema/ConstituencyGroup')
    end

    it 'renders the current_constituency template' do
      expect(response).to render_template('current_constituency')
    end
  end

  describe "GET houses" do
    before(:each) do
      get :houses, params: { person_id: 'ff75cd0c-1a8b-49ab-8292-f00d153588e5' }
    end

    it 'should have a response with http status ok (200)' do
      expect(response).to have_http_status(:ok)
    end

    it 'assigns @person and @incumbencies' do
      expect(assigns(:person)).to be_a(Grom::Node)
      expect(assigns(:person).type).to eq('http://id.ukpds.org/schema/Person')

      assigns(:incumbencies).each do |incumbency|
        expect(incumbency).to be_a(Grom::Node)
        expect(incumbency.type).to eq('http://id.ukpds.org/schema/Incumbency')
      end
    end

    it 'assigns @incumbencies in reverse chronological order' do
      expect(assigns(:incumbencies)[0].start_date).to eq(DateTime.new(2015, 5, 7))
      expect(assigns(:incumbencies)[1].start_date).to eq(DateTime.new(2010, 5, 6))
    end

    it 'renders the parties template' do
      expect(response).to render_template('houses')
    end
  end

  describe "GET current_house" do
    before(:each) do
      get :current_house, params: { person_id: 'ff75cd0c-1a8b-49ab-8292-f00d153588e5' }
    end

    it 'should have a response with http status ok (200)' do
      expect(response).to have_http_status(:ok)
    end

    it 'assigns @person and @house' do
      expect(assigns(:person)).to be_a(Grom::Node)
      expect(assigns(:person).type).to eq('http://id.ukpds.org/schema/Person')
      expect(assigns(:house)).to be_a(Grom::Node)
      expect(assigns(:house).type).to eq('http://id.ukpds.org/schema/House')
    end

    it 'renders the current_house template' do
      expect(response).to render_template('current_house')
    end
  end

  describe 'GET letters' do
    context 'there is a response' do
      before(:each) do
        get :letters, params: {letter: 't'}
      end

      it 'should have a response with http status ok (200)' do
        expect(response).to have_http_status(:ok)
      end

      it 'assigns @people and @letters' do
        assigns(:people).each do |person|
          expect(person).to be_a(Grom::Node)
          expect(person.type).to eq('http://id.ukpds.org/schema/Person')
        end

        expect(assigns(:letters)).to be_a(Array)
      end

      it 'assigns @people in alphabetical order' do
        expect(assigns(:people)[0].given_name).to eq('Person 1 - forename')
        expect(assigns(:people)[1].given_name).to eq('Person 2 - forename')
      end

      it 'renders the letters template' do
        expect(response).to render_template('letters')
      end
    end

    context 'there is no response' do
      before(:each) do
        get :letters, params: {letter: 'x'}
      end

      it 'http status of 200' do
        expect(response).to have_http_status(200)
      end

      it 'has a blank @people array' do
        expect(controller.instance_variable_get(:@people)).to be_empty
      end
    end
  end

  describe 'GET members_letters' do
    context ' there is a response ' do
      before(:each) do
        get :members_letters, params: {letter: 't'}
      end

      it 'should have a response with http status ok (200)' do
        expect(response).to have_http_status(:ok)
      end

      it 'assigns @people and @letters' do
        assigns(:people).each do |person|
          expect(person).to be_a(Grom::Node)
          expect(person.type).to eq('http://id.ukpds.org/schema/Person')
        end

        expect(assigns(:letters)).to be_a(Array)
      end

      it 'assigns @people in alphabetical order' do
        expect(assigns(:people)[0].given_name).to eq('Person 1 - forename')
        expect(assigns(:people)[1].given_name).to eq('Person 2 - forename')
      end

      it 'renders the members_letters template' do
        expect(response).to render_template('members_letters')
      end
    end

    context 'there is no response' do
      before(:each) do
        get :members_letters, params: {letter: 'x'}
      end

      it 'http status of 200' do
        expect(response).to have_http_status(200)
      end

      it 'has a blank @people array' do
        expect(controller.instance_variable_get(:@people)).to be_empty
      end
    end
  end

  describe "GET current_members_letters" do
    context 'there is a response' do
      before(:each) do
        get :current_members_letters, params: {letter: 't'}
      end

      it 'should have a response with http status ok (200)' do
        expect(response).to have_http_status(:ok)
      end

      it 'assigns @people and @letters' do
        assigns(:people).each do |person|
          expect(person).to be_a(Grom::Node)
          expect(person.type).to eq('http://id.ukpds.org/schema/Person')
        end

        expect(assigns(:letters)).to be_a(Array)
      end

      it 'assigns @people in alphabetical order' do
        expect(assigns(:people)[0].given_name).to eq('Person 1 - givenName')
        expect(assigns(:people)[1].given_name).to eq('Person 2 - givenName')
      end

      it 'renders the current_members_letters template' do
        expect(response).to render_template('current_members_letters')
      end
    end

    context 'there is no response' do
      before(:each) do
        get :current_members_letters, params: {letter: 'x'}
      end

      it 'should have a response with a http status of 200' do
        expect(response).to have_http_status(200)
      end

      it 'should have a blank @people array' do
        expect(controller.instance_variable_get(:@people)).to be_empty
      end
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
      get :a_to_z_members
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
      get :a_to_z_current_members
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
        get :lookup_by_letters, params: {letters: 'cam'}
      end

      it 'should have a response with http status redirect (302)' do
        expect(response).to have_http_status(302)
      end

      it 'redirects to people/a-z/cam' do
        expect(response).to redirect_to(people_a_z_letter_path(letter: 'cam'))
      end
    end

    context 'it returns a single result' do
      before(:each) do
        get :lookup_by_letters, params: {letters: 'creasy'}
      end

      it 'should have a response with http status redirect (302)' do
        expect(response).to have_http_status(302)
      end

      it 'redirects to people/:id' do
        expect(response).to redirect_to(person_path('c9e343c4-0c1f-4d74-b966-b2c8260b8382'))
      end
    end
  end

  describe 'rescue_from Parliament::NoContentError' do
    it 'raises an ActionController::RoutingError' do
      expect{ get :show, params: { person_id: 'a11425ca-6a47-4170-80b9-d6e9f3800a52' } }.to raise_error(ActionController::RoutingError)
    end
  end
end
