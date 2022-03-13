import prismaClientPackage from '@prisma/client'
import argon2 from 'argon2'
import jsonwebtoken from 'jsonwebtoken'

const prisma = new prismaClientPackage.PrismaClient()

export default function handler(request, response) {
  const { email, password } = request.body

  return prisma.user
    .findUnique({ where: { email } })
    .then((user) =>
      argon2.verify(user.password, password).then((matches) => {
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
      response.status(500).send({ message: 'Sorry, signin failed :(' })
    })
    .finally(() => prisma.$disconnect())
}
