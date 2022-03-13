import prismaClientPackage from '@prisma/client'
import argon2 from 'argon2'
import jsonwebtoken from 'jsonwebtoken'

const prisma = new prismaClientPackage.PrismaClient()

export default function handler(request, response) {
  const { email, password, name } = request.body

  return argon2
    .hash(password)
    .then((password) =>
      prisma.user.create({ data: { email, password, name } }).then((user) => {
        const token = jsonwebtoken.sign(
          {
            id: user.id,
            email: user.email,
            name: user.name
          },
          process.env.JWT_SECRET
        )

        response.status(200).send({ jwt: token })
      })
    )
    .catch((error) => {
      console.error(error)
      response.status(500).send({ message: 'Sorry, signup failed :(' })
    })
    .finally(() => prisma.$disconnect())
}
