/*
  Warnings:

  - You are about to drop the column `target_user_id` on the `restaurant_invite_codes` table. All the data in the column will be lost.

*/
-- DropForeignKey
ALTER TABLE "restaurant_invite_codes" DROP CONSTRAINT "restaurant_invite_codes_target_user_id_fkey";

-- AlterTable
ALTER TABLE "restaurant_invite_codes" DROP COLUMN "target_user_id";
