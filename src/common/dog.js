class Dog {
  constructor(name) {
    this.name = name;
  }

  bark() {
    return `Wah wah, I am ${this.name}`;
  }

  barkInConsole() {
    // eslint-disable-next-line no-console
    console.log(this.bark());
  }
}

export default Dog;
