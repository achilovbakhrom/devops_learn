function test () {
  console.log('123');
}

function test2 () {
  test();
}

const obj = {
  name: 'myName'
};

obj.name = '123';

test2();
