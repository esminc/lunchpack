document.addEventListener('turbolinks:load', function() {
  const memberRows = document.querySelectorAll('.member-row');

  for(const memberRow of memberRows) {
    memberRow.addEventListener('click', function(){
      const forms = document.querySelectorAll('.member-form');
      if (Array.from(forms).every(form => form.value !==''))
        return;

      if (!memberRow.classList.contains('unselectable-row')){
        memberRow.classList.add('selected-row');

        makeUnselectableRows();

        const form = findEmptyForm(forms);
        form.value = memberRow.querySelector('.member-name').textContent;

        form.addEventListener('click', function(){
          form.value = '';
          memberRow.classList.remove('selected-row');
          makeUnselectableRows();
        });
      }
    });
  }

  fillInFirstMemberWithLoginMember();

  function fillInFirstMemberWithLoginMember() {
    for(const memberRow of memberRows) {
      if (memberRow.querySelector('.member-name').textContent === gon.login_member["real_name"])
        memberRow.click();
    }
  }

  // 選択できないメンバーに関する処理
  function makeUnselectableRows(){
    for(const memberRow of memberRows) {
      memberRow.classList.remove('unselectable-row');
      memberRow.querySelector('.unselectable-reason').textContent = '';
      addUnselectableReason(memberRow);
      if (memberRow.querySelector('.unselectable-reason').textContent !== ''){
        visualizeUnselectable(memberRow);
      }
    }
  }

  function addUnselectableReason(memberRow){
    const selectedMemberRows = document.querySelectorAll('.selected-row');
    const memberProjects = memberRow.querySelector('.member-project').textContent.split(',').filter(n => n !== '');
    const memberName = memberRow.querySelector('.member-name').textContent;
    const unselectableReason = memberRow.querySelector('.unselectable-reason');
    const sameProjectMemberNamesInSelectedMembers = [];
    const usedBenefitMemberNamesInSelectedMembers = [];

    for (const selectedMemberRow of selectedMemberRows) {
      const selectedMemberProjects = selectedMemberRow.querySelector('.member-project').textContent.split(',').filter(n => n !== '');
      if (existsIntersection(memberProjects, selectedMemberProjects)) {
        sameProjectMemberNamesInSelectedMembers.push(selectedMemberRow.querySelector('.member-name').textContent);
      }

      const selectedMemberName = selectedMemberRow.querySelector('.member-name').textContent
      for (const trio of gon.lunch_trios) {
        const names = trio.map(e => e["real_name"]);
        if ((names.includes(memberName)) && (names.includes(selectedMemberName))) {
          usedBenefitMemberNamesInSelectedMembers.push(selectedMemberName);
        }
      }
    }

    if (sameProjectMemberNamesInSelectedMembers.length > 0) {
      unselectableReason.innerHTML += `${sameProjectMemberNamesInSelectedMembers.flat().join(',')}と同じプロジェクト`;
    }

    if (usedBenefitMemberNamesInSelectedMembers.length > 0) {
      if (unselectableReason.textContent !== '') {unselectableReason.innerHTML += '<br>';}
      unselectableReason.innerHTML += `${usedBenefitMemberNamesInSelectedMembers.flat().join(',')}とランチ済み`;
    }
  }

  function visualizeUnselectable(memberRow) {
    memberRow.classList.add('unselectable-row');
  }

  function existsIntersection(arr1, arr2){
    const set1 = new Set(arr1);
    const set2 = new Set(arr2);
    const intersection =  new Set([...set1].filter(e => (set2.has(e))));
    return intersection.size !== 0;
  }

  function findEmptyForm(forms) {
    return Array.from(forms).find(form => form.value === '');
  }
});
