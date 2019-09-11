document.addEventListener('turbolinks:load', function() {
  $('.tabs').tabs();

  const memberRows = document.querySelectorAll('.member-row');

  for(const memberRow of memberRows) {
    memberRow.addEventListener('click', function(){
      const forms = document.querySelectorAll('.member-form');
      if (Array.from(forms).every(form => form.value !==''))
        return;

      if (!memberRow.classList.contains('unselectable-row')){
        memberRow.classList.add('selected-row');

        noDisplayMember();

        const form = findEmptyForm(forms);
        form.value = memberRow.querySelector('.member-name').textContent;

        form.addEventListener('click', function(){
          form.value = '';
          memberRow.classList.remove('selected-row');
          noDisplayMember();
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
  

  // どのメンバーを表示しないか
  function noDisplayMember(){
    for(const memberRow of memberRows) {
      memberRow.classList.remove('unselectable-row');
      memberRow.querySelector('.unselectable-reason').textContent = '';
      const bool1 = hasSameProjects(memberRow);
      const bool2 = isUsedBenefitWithSelectedMembers(memberRow);
      if (bool1 || bool2){
        memberRow.classList.add('unselectable-row');
      }
    }
  }

  function hasSameProjects(memberRow) {
    const ns = [];
    const selectedProjects = Array
      .from(document.querySelectorAll('.selected-row'))
      .map(row => row.querySelector('.member-project').textContent.split(','))
      .flat()
      .filter(n => n !== '');
    const selectedMemberRows = document.querySelectorAll('.selected-row');
    const memberProjects = memberRow.querySelector('.member-project').textContent.split(',').filter(n => n !== '');
    for(const selectedMemberRow of selectedMemberRows) {
      const selectedMemberProjects = selectedMemberRow.querySelector('.member-project').textContent.split(',').filter(n => n !== '');
      if (existsIntersection(memberProjects, selectedMemberProjects)){
        ns.push(selectedMemberRow.querySelector('.member-name').textContent);
      }
    }
    if (ns.length > 0){
      memberRow.querySelector('.unselectable-reason').innerHTML += `${ns.flat().join(',')}と同じプロジェクト`;
      return true;
    } else {
      return false;
    };
  }

  function isUsedBenefitWithSelectedMembers(memberRow) {
    const memberName = memberRow.querySelector('.member-name').textContent;
    const selectedNames = Array
      .from(document.querySelectorAll('.selected-row'))
      .map(row => row.querySelector('.member-name').textContent);
    const ns = [];
    for(const trio of gon.lunch_trios) {
      const names = trio.map(e => e["real_name"]);
      for(selectedName of selectedNames) {
        if ((names.includes(memberName)) && (names.includes(selectedName)))
          ns.push(selectedName);
      }
    };
    if (ns.length > 0){
      if (memberRow.querySelector('.unselectable-reason').textContent !== '')
        memberRow.querySelector('.unselectable-reason').innerHTML += '<br>';
      memberRow.querySelector('.unselectable-reason').innerHTML += `${ns.flat().join(',')}とランチ済み`;
      return true;
    } else {
      return false;
    };
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
