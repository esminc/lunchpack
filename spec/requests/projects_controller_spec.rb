require 'rails_helper'

RSpec.describe ProjectsController, type: :request do
  describe 'PATCH #update' do
    let!(:project) { create(:project, name: '旧プロジェクト') }

    before do
      sign_in create(:user)
    end

    context 'パラメータが妥当な場合' do
      let(:params) { {project: {name: '新プロジェクト'}} }

      it 'プロジェクト名が更新されること' do
        expect { patch project_url(project, params: params) }
          .to change { project.reload.name }.from('旧プロジェクト').to('新プロジェクト')
      end

      it 'リダイレクトすること' do
        patch project_url(project, params: params)
        expect(response).to redirect_to projects_url
      end
    end

    context 'パラメータが不当な場合' do
      let(:params) { {project: {name: ''}} }

      it 'プロジェクト名が更新されないこと' do
        expect { patch project_url(project, params: params) }.not_to change { project.reload.name }
      end

      it 'エラーメッセージが表示されること' do
        patch project_url(project, params: params)
        expect(response.body).to include 'プロジェクト名を入力してください'
      end
    end
  end
end
